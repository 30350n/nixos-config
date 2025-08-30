import sys
from pathlib import Path

import fontforge
import psMat

font = fontforge.open(sys.argv[1])
font_name = Path(sys.argv[1]).name
italic = font.italicangle != 0

# use mirrored small y for lambda
if not italic and (SMALL_Y := "y") in font and (LAMBDA := 0x03BB) not in font:
    print(f"adding lambda to '{font_name}' ...")
    glyph_y = font[SMALL_Y]
    glyph_lambda = font.createChar(LAMBDA)
    glyph_lambda.width = glyph_y.width
    glyph_lambda.foreground = glyph_y.foreground
    glyph_lambda.transform(psMat.scale(1, -1))
    glyph_lambda.transform(psMat.translate(0, -glyph_lambda.boundingBox()[1]))
    glyph_lambda.correctDirection()
    glyph_lambda.autoHint()
    glyph_lambda.autoInstr()

    top_left_points = sorted(
        (
            point
            for contour in glyph_lambda.foreground
            for point in contour
            if point.on_curve and point.type in {fontforge.splineCorner, fontforge.splineTangent}
        ),
        key=lambda point: (point.y, -point.x),
    )[-3:][::-1]

    assert top_left_points[0].y == top_left_points[1].y
    assert top_left_points[0].x == top_left_points[2].x

    glyph_lambda.addAnchorPoint("Anchor-0", "base", 300, 0)
    glyph_lambda.addAnchorPoint(
        "Anchor-2",
        "base",
        (top_left_points[0].x + top_left_points[1].x) * 0.5,
        (top_left_points[0].y + top_left_points[2].y) * 0.5,
    )

# add mirrored small v for small turned v
if not italic and (SMALL_V := "v") in font and (SMALL_TURNED_V := 0x028C) not in font:
    print(f"adding turned v to '{font_name}' ...")
    glyph_v = font[SMALL_V]
    glyph_turned_v = font.createChar(SMALL_TURNED_V)
    glyph_turned_v.width = glyph_v.width
    glyph_turned_v.foreground = glyph_v.foreground
    glyph_turned_v.transform(psMat.scale(1, -1))
    glyph_turned_v.transform(psMat.translate(0, -glyph_turned_v.boundingBox()[1]))
    glyph_turned_v.correctDirection()
    glyph_turned_v.autoHint()
    glyph_turned_v.autoInstr()

    glyph_turned_v.addAnchorPoint("Anchor-0", "base", 300, 0)
    glyph_turned_v.addAnchorPoint("Anchor-2", "base", 300, glyph_turned_v.boundingBox()[3])

# use scaled down nf-fa-diamond for black diamond
if (NF_FA_DIAMOND := 0xF29F) in font and (BLACK_DIAMOND := 0x25C6) not in font:
    print(f"adding black diamond to '{font_name}' ...")
    glyph_nf_diamond = font[NF_FA_DIAMOND]
    glyph_diamond = font.createChar(BLACK_DIAMOND)
    glyph_diamond.foreground = glyph_nf_diamond.foreground
    bounding_box = glyph_diamond.boundingBox()
    scale = 600 / (bounding_box[2] - bounding_box[0])
    glyph_diamond.transform(psMat.scale(scale, scale))
    glyph_diamond.width = glyph_nf_diamond.width
    bounding_box = glyph_diamond.boundingBox()
    glyph_diamond.transform(
        psMat.translate(
            300 - (bounding_box[2] + bounding_box[0]) * 0.5,
            400 - (bounding_box[3] + bounding_box[1]) * 0.5,
        )
    )
    glyph_diamond.autoHint()
    glyph_diamond.autoInstr()

font.generate(str(Path(sys.argv[2]) / font_name))
