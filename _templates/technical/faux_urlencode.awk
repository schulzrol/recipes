#!/usr/bin/awk

# faux urlencode, replaces non-alphanumeric characters with their ascii
# "codepoints" but notably without a leading "%", also removes spaces and turns
# uppercase lowercase (so, basically, something very different indeed); based on
# https://gist.github.com/moyashi/4063894 (changes are noted below)

BEGIN {
    for (i = 0; i <= 255; i++) {
        ord[sprintf("%c", i)] = i
    }

    # Mapping of Czech diacritic characters to their non-diacritic equivalents
    diacritic["á"] = "a"; diacritic["č"] = "c"; diacritic["ď"] = "d";
    diacritic["é"] = "e"; diacritic["ě"] = "e"; diacritic["í"] = "i";
    diacritic["ň"] = "n"; diacritic["ó"] = "o"; diacritic["ř"] = "r";
    diacritic["š"] = "s"; diacritic["ť"] = "t"; diacritic["ú"] = "u";
    diacritic["ů"] = "u"; diacritic["ý"] = "y"; diacritic["ž"] = "z";
    diacritic["Á"] = "a"; diacritic["Č"] = "c"; diacritic["Ď"] = "d";
    diacritic["É"] = "e"; diacritic["Ě"] = "e"; diacritic["Í"] = "i";
    diacritic["Ň"] = "n"; diacritic["Ó"] = "o"; diacritic["Ř"] = "r";
    diacritic["Š"] = "s"; diacritic["Ť"] = "t"; diacritic["Ú"] = "u";
    diacritic["Ů"] = "u"; diacritic["Ý"] = "y"; diacritic["Ž"] = "z";
}

function remove_diacritics(str, c, res) {
    res = ""
    len = length(str)
    for (i = 1; i <= len; i++) {
        c = substr(str, i, 1)
        if (c in diacritic) {
            res = res diacritic[c]
        } else {
            res = res c
        }
    }
    return res
}

function encode(str, c, len, res) {
    str = tolower(str)                              # added
    str = remove_diacritics(str)                    # added
    len = length(str)
    res = ""
    for (i = 1; i <= len; i++) {
        c = substr(str, i, 1)
        if (c ~ /[0-9a-z]/)                         # changed to only lowercase
            res = res c
        else if (c == " ")                          # added
            res = res "_"                           # added
        else
            #res = res "%" sprintf("%02X", ord[c])  # removed
            res = res sprintf("%02X", ord[c])       # added
    }
    return res
}

{ print encode($0) }
