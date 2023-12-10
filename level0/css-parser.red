Red [
  About: "Apricot CSS Parser, starting off"
]
parse-css: func [css [string!]] [
    styles: make block! []
    parse css [
        any [
            skip thru ["{" | newline]
            "{" (collect [
                some [copy property to ":" skip copy value to ";" skip | skip]
            ]) ";" (
                style: make object! []
                repeat i (length? property) [
                    set in style property/:i to value/:i
                ]
                append styles style
            )
        ]
    ]
    styles
]
