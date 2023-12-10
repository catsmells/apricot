Red [
  About: "Apricot DOM Parser."
]
make-node: func [
    type [word!]
    value [string!]
    children [block!]
][
    reduce [type value children]
]
parse-html: func [html [string!]] [
    stack: make stack!
    root: none
    current: none
    parse html [
        any [
            "<" (collect [
                some [copy tag to ">" | skip]) ">" (
                    node: make-node 'element tag [])
                    if not root [root: node]
                    if current [append current  node]
                    push stack current
                    current: node
            |
                thru "<" (
                    node: make-node 'text copy text to "<")
                    if current [append current node]
                    current: pop stack
            ]
        ]
    ]
]
