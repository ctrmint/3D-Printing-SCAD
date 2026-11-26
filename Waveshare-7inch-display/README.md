# Waveshare 7-inch Touchscreen - Version 5 - Separate OpenSCAD Parts

The two self-contained OpenSCAD files below can be opened and exported independently. They use the same geometry as the existing two-piece Version 5 enclosure:

- `Waveshare_Touch7_Main_Body_V5.scad`: protective bezel, enclosure walls, seven side connector openings, rear-door heat-set insert holes.
- `Waveshare_Touch7_Rear_Door_V5.scad`: removable rear door, four integrated M3 display-mounting pillars, six case fasteners, ventilation.

To create STLs, open each `.scad` file separately in OpenSCAD, press **F6** (render), then choose **File > Export > Export as STL**. There are only **two printed pieces**.

## Dimensional coordination

Both models share these critical dimensions: `case_w=210`, `case_h=128`, `case_corner_r=8`, `body_depth=32`, and the six `door_fixings()` points. If you modify them, update BOTH files.

The screen mounting pattern is `126.20 × 65.65 mm`. Hole offsets, the assumed `15.5 mm` glass-to-mount reference, display stack-up and connector centres are unverified against the physical display. Test fit the screen, screw length, USB-C plug insertion and cables before applying force or tightening fasteners.

The two files are standalone, with no external library or STL imports. Both use the original Version 5 geometry; they have not been redesigned or re-engineered in this split.
