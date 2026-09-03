# 3D-Printing-SCAD

A small, growing collection of parametric [OpenSCAD](https://openscad.org/) designs for FDM 3D printing.

Everything here started as something I wanted for myself and then got tidied up enough to be useful to
someone else. It's not a product and it's not commercial — it's a friendly "here, this might save you
an afternoon" sort of repo. Take what's useful, change what isn't, no need to ask.

Each design lives in its own folder with the `.scad` source, a ready-to-print `.stl`, a render, and a
README explaining what it fits, how to print it, and which knobs to turn.

## Designs

| Design | What it is | Status |
| --- | --- | --- |
| [gopro11_battery_charger_case](gopro11_battery_charger_case/) | Storage case for 4 loose GoPro HERO11 batteries plus the OEM ADDBD-211 dual charger, with a snap-fit lid | Printable, one known limitation — see its README |

More will get added over time as I make them.

## Why OpenSCAD

Every model here is *parametric*: the dimensions live in named variables at the top of the file, not
baked into the geometry. That matters because your printer isn't my printer. If a pocket comes out too
tight, you change one clearance number and re-export instead of filing plastic or redrawing the model.

Each design's README lists the handful of parameters actually worth touching.

## Getting started

1. **Install OpenSCAD** — <https://openscad.org/downloads.html>. It's free and runs on Linux, macOS
   and Windows.
2. **Open the `.scad` file** for the design you want.
3. **Edit the parameters** in the `USER PARAMETERS` block near the top.
4. **Preview** with `F5` (fast, rough) and **render** with `F6` (slow, exact — required before export).
5. **Export STL** with `F7`.

The `Design → Display CSG Products` console also prints a block of useful derived dimensions after a
render (finished size, pocket sizes, clearances) so you can sanity-check a change without measuring
the model.

Prefer the command line? Every design renders headlessly:

```sh
openscad -o output.stl path/to/design.scad
```

You can override any top-level parameter without editing the file:

```sh
openscad -D 'part="lid"' -D 'slots=6' -o lid.stl path/to/design.scad
```

Designs are checked against **OpenSCAD 2021.01**. Newer releases should be fine.

## If you just want to print

Every folder has an `.stl` already exported with the default parameters. Grab it, slice it, go. The
`.scad` file is there for when the defaults don't suit you.

The STLs are kept in sync with their source — they're re-exported whenever the `.scad` changes.

## General print notes

These are starting points; per-design READMEs override them where it matters.

- **Material:** PLA is fine for everything here. PETG if it'll live in a hot car.
- **Layer height:** 0.2 mm.
- **Perimeters:** 3. Walls are sized as sensible multiples of a 0.4 mm nozzle.
- **Infill:** 15–20 % — these are storage parts, not structural ones.
- **Supports:** not needed if you use the orientation the design README specifies. If a design needs
  supports, that's a design bug and I'd rather fix it.

## A word on fit

Any design that holds a real-world object (a battery, a charger, a connector) has nominal dimensions
written at the top of its `.scad`, taken from published specs or my own calipers. Published specs get
rounded, and printers over- or under-extrude differently.

**If fit matters to you, measure your part and update the numbers before printing.** Every design
separates the *object* dimensions from the *clearance* values so you can tune them independently.
Printing a small test section first is cheaper than printing the whole thing twice.

## Repo layout

```
<design_name>/
├── README.md          what it fits, how to print it, what to tune
├── <design>.scad      parametric source — the real deliverable
├── <design>.stl       exported with default parameters
└── render.png         what it looks like
```

## Feedback

If something doesn't fit, doesn't print, or doesn't make sense, open an issue. Notes like "this pocket
was 0.3 mm too tight on a Prusa MK4 in PETG" are genuinely the most useful thing you can send — that's
exactly the kind of thing the parameters exist to absorb.

## Licence

Licensed under [Creative Commons Attribution-ShareAlike 4.0 International][cc-by-sa] (CC BY-SA 4.0).
Full text in [`LICENSE`](LICENSE).

In plain terms — print them, modify them, remix them, sell what you print, no need to ask. Two
conditions:

- **Credit the original.** A link back is plenty.
- **Share alike.** If you publish a modified version of a design, licence it CC BY-SA 4.0 too, so the
  next person gets the same freedoms you did.

That second one is the whole reason for picking ShareAlike over plain CC BY: if you improve one of
these, the improvement stays available to everyone else rather than disappearing into a closed remix.

No warranty of any kind — you're printing plastic, use your judgement.

[cc-by-sa]: https://creativecommons.org/licenses/by-sa/4.0/
