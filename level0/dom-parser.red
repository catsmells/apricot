Red [
  About: "Apricot DOM Parser."
]
dom-renderer: func [element] [
    switch type? element [
        string! [
            print element
        ]
        block! [
            tag: first element
            attrs: second element
            print rejoin ["<" tag]
            foreach [attr-name attr-value] attrs [
                print rejoin [" " attr-name "=" attr-value]
            ]
            print ">"
            foreach child third element [
                dom-renderer child
            ]
            print rejoin ["</" tag ">"]
        ]
    ]
]
dom-renderer html
