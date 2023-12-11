Red [
  About: "Apricot DOM Parser."
]
attr-map: context []
node: context [
    children: copy []
    node-type: none
]
element-data: context [
    tag-name: none
    attributes: attr-map
]
text: func [data [string!]] [
    node: make node [
        children: copy []
        node-type: 'text
    ]
    node/text: data
    node
]
elem: func [name [string!] attrs [attr-map] children [block!]] [
    node: make node [
        children: copy []
        node-type: 'element
    ]
    node/node-type: make element-data [
        tag-name: name
        attributes: attrs
    ]
    node/children: children
    node
]
ElementData: make element-data []
ElementData/id: func [] [
    get in attributes "id"
]
ElementData/classes: func [] [
    classlist: get in attributes "class"
    if classlist [
        split classlist " "
    ] [
        []
    ]
]

; Manual Example:

;node: elem "div" make attr-map ["id" "mydiv" "class" "myclass"] [
;    elem "p" make attr-map ["class" "paragraph"] [
;        text "Hello, World!"
;    ]
;]

print node
