# Assets

This directory contains placeholder asset files for demos and screenshots.

## Files

| File | Description |
|------|-------------|
| `demo.gif` | Animated GIF showing a terminal recording of the full demo workflow |
| `demo-screenshot.png` | Static screenshot showing generated reports or other project output |

## Generating Real Assets

### demo.gif

1. Set up the demo environment and ensure `bash examples/demo-project/run-demo.sh` works.
2. Record the terminal session using **asciinema**:
   ```bash
   asciinema rec demo.cast
   bash examples/demo-project/run-demo.sh
   exit
   ```
3. Convert to GIF using **agg** (asciinema GIF generator):
   ```bash
   agg --fps-cap 10 --last-frame-duration 3 demo.cast demo.gif
   ```
4. Alternatively, use QuickTime Player to record the screen, then convert with ffmpeg:
   ```bash
   ffmpeg -i demo.mov -vf "fps=10,scale=800:-1:flags=lanczos" -c:v gif demo.gif
   ```

### demo-screenshot.png

1. Run the demo to generate reports.
2. Open the generated report files in a browser or viewer.
3. Take a clean screenshot using your OS screenshot tool.
4. Crop and save as `demo-screenshot.png`.

## Notes

- These placeholders exist so that documentation and README files can reference asset paths that actually exist.
- Replace the placeholder files as soon as real assets are available.
- Keep GIFs under 5 MB and screenshots under 1 MB for repository friendliness.