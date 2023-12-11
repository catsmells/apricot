Red [
	About: "CSS Rendering Script for Apricot"
]

stylesheets: context [
    rules: []
]

rule: context [
    selectors: []
    declarations: []
]

selector: context [
    simple: none
]

simple-selector: context [
    tag_name: none
    id: none
    class: []
]

declaration: context [
    name: none
    value: none
]

value: context [
    keyword: none
    length: none
    color_value: none
]

color: context [
    r: 0
    g: 0
    b: 0
    a: 0
]

unit: context [
    px: none
]

parse-css: func [source [string!]] [
    parser: context [
        pos: 1
        input: source
    ]

    parse-rules: func [] [
        rules: copy []
        until [parser/eof] [
            parser/consume-whitespace
            if parser/eof [break]
            append rules parser/parse-rule
        ]
        rules
    ]

    parse-rule: func [] [
        rule: context [
            selectors: parser/parse-selectors
            declarations: parser/parse-declarations
        ]
        rule
    ]

    parse-selectors: func [] [
        selectors: copy []
        until [
            append selectors selector/simple: parser/parse-simple-selector
            parser/consume-whitespace
            case [
                parser/next-char = #{,} [parser/consume-char parser/consume-whitespace]
                parser/next-char = #{\{} [break]
                true [print ["Try an EXPECTED CHARACTER for once." parser/next-char "in selector list"] break]
            ]
        ]
        sort/skip/selectors func [a b] [back a/specificity < back b/specificity]
    ]

    parse-simple-selector: func [] [
        selector: context [
            simple: simple-selector [
                tag_name: none
                id: none
                class: []
            ]
        ]
        until [any [
            parser/eof
            case [
                parser/next-char = #{#} [parser/consume-char selector/simple/id: parser/parse-identifier]
                parser/next-char = #{.} [parser/consume-char append selector/simple/class parser/parse-identifier]
                parser/next-char = #{*} [parser/consume-char]
                valid-identifier-char? parser/next-char [selector/simple/tag_name: parser/parse-identifier]
                true [break]
            ]
        ]]
        selector/simple
    ]

    parse-declarations: func [] [
        parser/consume-char #{\{}
        declarations: copy []
        until [
            parser/consume-whitespace
            if parser/next-char = #{\}} [parser/consume-char break]
            append declarations parser/parse-declaration
        ]
        declarations
    ]

    parse-declaration: func [] [
        declaration: context [
            name: parser/parse-identifier
            value: parser/parse-value
        ]
        declaration
    ]

    parse-value: func [] [
        switch parser/next-char [
            #{0} - #{9} [parser/parse-length]
            #{#} [parser/parse-color]
            true [value/keyword: parser/parse-identifier value]
        ]
    ]

    parse-length: func [] [
        value/length: context [
            length: parser/parse-float
            unit: parser/parse-unit
        ]
        value
    ]

    parse-float: func [] [
        s: parser/consume-while func [c] [c >= #{0} and c <= #{9} or c = #"."]
        to-float s
    ]

    parse-unit: func [] [
        unit: context [
            px: none
        ]
        unit/px
