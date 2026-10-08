# Blong

Blong is a landscape-only iPhone game (Pong × Breakout), written in Objective-C with SpriteKit, dating from 2013–2014. Two paddles (left/right, each driven by a thumb) bounce balls into a central brick wall. ARC, iPhone only, deployment target iOS 8.0. There are no dependencies or package managers; file membership, resources, and build settings live in `Blong.xcodeproj/project.pbxproj`. If you add a source file or asset, add it to the `Blong` target in the project file too, or it won't be compiled or bundled.

## Build and test

```sh
xcodebuild -list -project Blong.xcodeproj
xcodebuild -project Blong.xcodeproj -scheme Blong -destination 'generic/platform=iOS Simulator' build
```

- The only scheme is in `xcuserdata/will.xcuserdatad`, which isn't shared, so other users or checkouts may need Xcode to create it automatically.
- Current Xcode releases no longer support iOS 8.0 as a deployment target. The build may need `IPHONEOS_DEPLOYMENT_TARGET` raised. Don't raise it as a side effect of unrelated work without saying so.
- `BlongTests/BlongTests.m` contains only the template `XCTFail` placeholder, so `xcodebuild test` always fails. That failure doesn't mean gameplay broke.
- There's no lint or formatter configuration. Match the surrounding style: 4-space indent, `-(void)method` spacing, direct `_ivar` access, class factory methods like `+brickWithScene:`, and behavior built from `SKAction` sequences and `runBlock:`.

## Scene flow

`BlongViewController` → `BlongMainMenu` (tap to start) → `BlongMyScene` (gameplay) → `BlongGameOverScene` (tap to replay). `BlongPauseMenu` is its own scene. It keeps the paused `BlongMyScene` in a file-scope global (`blongScene`) and presents it again on CONTINUE. `BlongAppDelegate` pauses the `SKView` on resign-active and shows the pause menu on become-active if gameplay was running.

`BlongLoadingScene` and `BlongThumbHole` are compiled into the app but never used.

## Gameplay (`BlongMyScene.m`, about 930 lines, where almost everything happens)

- **Tuning constants** sit at the top of the file as globals: velocity (`baseMaxVelocity`, `incMaxVelocity`…), grid size (`baseRows/maxRows`, `baseCols/maxCols`), the brick-respawn interval (`baseCockBlock`…), the one-ball countdown (`baseCountdown`…), `bonusLevelEvery = 3`, and the tappable-brick counts. Difficulty is scaled from `_level` in `startLevel`, `calcLevelVelocity`, `incrementCockblock:`, and `startCountdown`.
- **Level 1 (tutorial):** the bricks are placed without animation. Each paddle stays dynamic until the player first touches that side. The first touch fires a ball (`shootBallAtPoint:`) and calls `getPhysical` to make the paddle static. `started` becomes true only after both sides have been touched.
- **Level `_introduceTappable` (4):** a single spinning tappable brick in the center. Tapping it advances the level.
- **Normal levels:** a READY/STEADY/BLONG intro sequence with fixed delays. Two balls fly in, and the bricks animate in. Some bricks are made tappable (orange, `touchBlockColor`) and are destroyed by touch instead of by ball. Paddles shrink a little each level.
- **Breakthrough:** the first time a full row is cleared, a bonus ball spawns at the last cleared slot.
- **Cockblock timer:** an `NSTimer` that periodically adds a brick back.
- **Countdown:** with one ball left (except on levels 1 and 4, or with the NO COUNTDOWN powerup), a red timer starts. Reaching 0 ends the game. Zero balls also ends the game.
- **Bonus level:** every 3rd level. 20 balls, a 10s countdown, no bricks. It ends when the timer runs out or every ball is lost.
- **Powerups:** awarded in `newLevel` based on balls kept. Two balls gives one random minor reward (bigger paddles, 50 points, or slowdown). Three or more gives a "three-ball" powerup from `_threeBallPowerups`, an `NSMutableDictionary` of name → `[remainingLevels, iconSprite]`. Each grant adds 4 levels, and the count drops by 1 per non-bonus level. Check with `powerupActive:`. The dictionary keys are the on-screen display strings.
- **Score:** points pile up in `scoreToAdd`, and `update:` moves them into `_score` one per frame so the counter ticks up.

### Brick grid

`_bricks` is an array of columns, each holding `_rows` entries. Each entry is a `BlongBrick` or `NSNull`. A slot number is `row * cols + col`. `_availableBlockSlots` holds the **empty** slots, so the level is cleared when `_availableBlockSlots.count == _rows * _cols`. Brick height is scaled by `6.0 / rows`.

### Physics

Gravity is zero. The category masks are `ballCat`, `paddleCat`, `wallCat`, `brickCat`, and `tappableBrickCat` (in `BlongMyScene.m`). Only the top and bottom walls exist, and a ball that leaves the screen sideways is removed. When a ball hits a paddle, `didBeginContact:` replaces its velocity based on where it struck the paddle (hits on the paddle's back are ignored). The WRECKING BALLS powerup removes `brickCat` from the ball's collision mask, so balls pass through bricks while still registering contacts. Setting `physicsWorld.speed = 0` freezes play between levels.

## Gotchas

- **File-scope globals are shared across scene instances.** `BlongMyScene.m` keeps game state in non-static C globals (`started`, `touchedLeft`, `touchedRight`, `isBonusLevel`, `levelVelocity`, the preloaded sound actions, …). Most are reset in `initWithSize:`, but not all (`isBonusLevel`, for example). Other files do the same (`go`, `goGameOver`, `blongScene`, `float scale` in `BlongPaddle.m`). These globals aren't `static`, so new globals with the same names will cause linker collisions.
- **Debug toggles are local `BOOL`s in the code:** `invincible` and `skipTutorial` in `BlongMyScene initWithSize:`, `debugTappable` in `touchesEnded:`, and `gameCenter` in `BlongAppDelegate.m`. Leave them `NO`/`YES` as they are before shipping.
- **Timers:** the countdown and cockblock timers are `NSTimer`s, not `SKAction`s, so they skip ticks by checking `self.paused` rather than pausing with the scene.
- **iOS version checks:** some code still branches on `systemVersion` to handle iOS 7 (paddle resize, scene size in `BlongViewController`).
- **Shared look:** colors and fonts come from `AppConstants.h` macros (`tintColor`, `darknessColor`, `headFont` = "Hyperspace Bold", …). The fonts are bundled TTFs listed under `UIAppFonts`.
- **Game Center:** `BlongGameCenterHelper` uses the leaderboard ID `default2014` and caches the high score in memory. It runs on deprecated GameKit APIs (`GKScore`, `playerID`).

## Assets

Sprites are mostly `@2x` PNGs loose in `Blong/` (files named `*_old`, `*_bak`, or `title_bak` are leftovers). Sound effects are `.wav`. `bip*` plays on paddle hits and `bop*` on brick hits, each picked at random. The intro music and game-over jingle are `.m4a`. The particle effect is `MyParticle.sks`. `other stuff/` isn't part of the build. It holds source sounds, App Store screenshots, icon sources, and an sfxr file.
