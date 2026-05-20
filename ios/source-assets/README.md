# iOS source assets

These are source image files to import into the future native iOS project.

- `cards/`: 26 bingo card source images stored as zero-padded PNG filenames (`card-01.png` ... `card-26.png`)
- `app-icon/`: original app icon source image (`app-icon.jpg`)
- `launch-screen/`: original launch screen source image (`launch-image.jpg`)

## Card normalization summary

### Final standard size
- Final normalized card size: `280 x 262` pixels
- Format: `PNG`
- Filenames: `card-01.png` ... `card-26.png`

### Normalization method
- Reviewed all 26 provided card source images
- Normalized every card to a single shared output size of `280 x 262`
- Preserved readability and framing as much as possible across the set
- Kept zero-padded sequential filenames for stable import ordering

## Validation summary

- Cards present: `26`
- Card format: `26 PNG files`
- Card dimensions: all `280 x 262`
- App icon present: `app-icon/app-icon.jpg`
- App icon format/dimensions: `JPEG`, `1024 x 1024`
- Launch image present: `launch-screen/launch-image.jpg`
- Launch image format/dimensions: `JPEG`, `1290 x 2796`

## Known risks / follow-up work

- These are staged source assets only; final iOS asset-catalog export/import is still pending
- Visual QA should be performed in the native iOS project after import to confirm cropping, padding, and readability on device
- If Apple platform requirements change, icon and launch artwork may need additional derived sizes/formats
