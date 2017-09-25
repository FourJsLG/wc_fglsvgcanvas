# FOURJS_START_COPYRIGHT(P,2017)
# Property of Four Js*
# (c) Copyright Four Js 2017, 2017. All Rights Reserved.
# * Trademark of Four Js Development Tools Europe Ltd
#   in the United States and elsewhere
# FOURJS_END_COPYRIGHT

# Sample modeled to mimic the follow W3C example
# https://www.w3schools.com/graphics/tryit.asp?filename=trysvg_ellipse2

IMPORT FGL fglsvgcanvas
IMPORT util

DEFINE selected_shape, change_style, gid, canvas STRING
DEFINE big_yn, medium_yn, small_yn BOOLEAN

DEFINE ellipse RECORD
    id STRING
END RECORD
  
DEFINE cid SMALLINT,
    root_svg, defs om.DomNode,
    attr DYNAMIC ARRAY OF om.SaxAttributes,
    g, g1, g2, g3, e1, e2, e3 om.DomNode
           
MAIN

  OPEN FORM f1 FROM "wc_fglsvgcanvas"
  DISPLAY FORM f1

  # Handler initialization and creation
  CALL fglsvgcanvas.initialize()
  LET cid = fglsvgcanvas.create("formonly.canvas")

  # Creating the root SVG node
  LET root_svg = fglsvgcanvas.setRootSVGAttributes( "myrootsvg",
                                   NULL, NULL,
                                   "0 0 500 500",
                                   "xMidYMid meet"
                                )

  LET big_yn = TRUE
  LET medium_yn = TRUE
  LET small_yn = TRUE
  LET change_style = "style_1"
  
  CALL set_style(change_style)
  CALL draw_ellipses()
  CALL fglsvgcanvas.display(cid)

  INPUT BY NAME big_yn, medium_yn, small_yn, selected_shape, change_style, canvas ATTRIBUTES (UNBUFFERED, WITHOUT DEFAULTS)

    ON ACTION svg_selection ATTRIBUTES(DEFAULTVIEW=NO)
      CALL util.JSON.parse( canvas, ellipse )
      LET selected_shape = ellipse.id

    ON CHANGE change_style
       CALL redraw()

    ON CHANGE  big_yn
      CALL redraw()

    ON CHANGE  medium_yn
      CALL redraw()

    ON CHANGE  small_yn
      CALL redraw()
       
    ON ACTION clean
      CALL fglsvgcanvas.clean(cid)
      # The clean() function will not automatically display the cleaned SVG canvas. To see a visual result, re-display the SVG content with the display() function.
      CALL fglsvgcanvas.display(cid)

    ON ACTION close
      EXIT INPUT

  END INPUT

  # Destroying the handler and releasing the resource
  CALL fglsvgcanvas.destroy(cid)
  CALL fglsvgcanvas.finalize()

END MAIN

FUNCTION set_style(current_style)

  DEFINE current_style STRING

  CASE current_style

    WHEN "style_1"
        LET attr[1] = om.SaxAttributes.create()
        CALL attr[1].addAttribute(SVGATT_FILL,           "lime" )
        LET attr[2] = om.SaxAttributes.create()
        CALL attr[2].addAttribute(SVGATT_FILL,           "purple" )
        LET attr[3] = om.SaxAttributes.create()
        CALL attr[3].addAttribute(SVGATT_FILL,           "yellow" )

    WHEN "style_2"
        LET attr[1] = om.SaxAttributes.create()
        CALL attr[1].addAttribute(SVGATT_FILL,           "red" )
        LET attr[2] = om.SaxAttributes.create()
        CALL attr[2].addAttribute(SVGATT_FILL,           "orange" )
        LET attr[3] = om.SaxAttributes.create()
        CALL attr[3].addAttribute(SVGATT_FILL,           "green" )

    OTHERWISE

  END CASE
  
  # Create set of CSS styles
  LET defs = fglsvgcanvas.defs( NULL )
  CALL defs.appendChild( fglsvgcanvas.styleList(
                          fglsvgcanvas.styleDefinition(".style_1",attr[1])
                       || fglsvgcanvas.styleDefinition(".style_2",attr[2])
                       || fglsvgcanvas.styleDefinition(".style_3",attr[3])
                       )
                     )
  CALL root_svg.appendChild( defs )

END FUNCTION--set_style

FUNCTION draw_ellipses()

 # Create group and apply some decoration to all objects in group
  LET g = fglsvgcanvas.g( "master" )
  CALL g.setAttribute(SVGATT_FILL_OPACITY,"0.3")
  CALL root_svg.appendChild( g )
  
  # Create 3 ellipses with 3 different colors using the predefined styles
  # Trick is to set 3 groups so shapes can be selected and detected

  IF (big_yn = TRUE) THEN
      LET gid = "big"
      LET g1 = fglsvgcanvas.g( gid )
      CALL g1.setAttribute("onclick","elem_clicked(this)")
      LET e1 = fglsvgcanvas.ellipse(240,100,220,30)
      CALL e1.setAttribute(SVGATT_CLASS,"style_1")
      CALL e1.setAttribute("id",gid)
      CALL g1.appendChild( e1 )
      CALL g.appendChild(g1)
  END IF

  IF (medium_yn = TRUE) THEN
      LET gid = "medium"
      LET g2 = fglsvgcanvas.g( gid )
      CALL g2.setAttribute("onclick","elem_clicked(this)")
      LET e2 = fglsvgcanvas.ellipse(220,70,190,20)
      CALL e2.setAttribute(SVGATT_CLASS,"style_2")
      CALL e2.setAttribute("id", gid)
      CALL g2.appendChild( e2 )
      CALL g.appendChild(g2)
  END IF

  IF (small_yn = TRUE) THEN
      LET gid = "small"
      LET g3 = fglsvgcanvas.g( gid )
      CALL g3.setAttribute("onclick","elem_clicked(this)")
      LET e3 = fglsvgcanvas.ellipse(210,45,170,15)
      CALL e3.setAttribute(SVGATT_CLASS,"style_3")
      CALL e3.setAttribute("id",gid)
      CALL g3.appendChild( e3 )
      CALL g.appendChild(g3)
  END IF
  
END FUNCTION--draw_ellipses


FUNCTION redraw()

  CALL fglsvgcanvas.clean(cid)
  CALL set_style(change_style)
  CALL draw_ellipses()
  CALL fglsvgcanvas.display(cid)

END FUNCTION--redraw