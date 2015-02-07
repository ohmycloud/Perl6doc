use URI::Escape;
class Perl6::Documentable {
    has Str $.kind;        # type, language doc, routine, module
    has Str @.subkinds;    # class/role/enum, sub/method, prefix/infix/...
    has Str @.categories;  # basic type, exception, operator...

    has Str $.name;
    has Str $.url;
    has Str $.filename;
    has     $.pod;
    has Bool $.pod-is-complete;
    has Str $.summary = '';

    # the Documentable that this one was extracted from, if any
    has $.origin;

    my sub english-list (*@l) {
        @l > 1
            ?? @l[0..*-2].join(', ') ~ " and @l[*-1]"
            !! ~@l[0]
    }
    method human-kind() {   # SCNR
        $.kind eq 'language'
            ?? 'language documentation'
            !! @.categories eq 'operator'
            ?? "@.subkinds[] operator"
            !! english-list @.subkinds // $.kind;
    }

    method filename() {
        $!filename //= $.kind eq 'operator'
            ?? "html/language/operators.html"
            !! "html/$.kind/$.name.html";
    }
    method url() {
        $!url //= $.kind eq 'operator'
            ?? "/language/operators#" ~ uri_escape("@.subkinds[] $.name".subst(/\s+/, '_', :g))
            !! ("", $.kind, $.name).map(&uri_escape).join('/')
            ;
    }
    method categories() {
        @!categories //= @.subkinds
    }
}

# vim: expandtab shiftwidth=4 ft=perl6
