pkg := "your-package"

emacs := env_var_or_default("EMACS", "emacs")
batch := emacs + " -Q --batch -L . -L test"

source-files := `find . -maxdepth 1 -name '*.el' ! -name '*-autoloads.el' ! -name '.dir-locals.el' | sort | tr '\n' ' '`
test-files   := `find test -maxdepth 1 -name '*.el' 2>/dev/null | sort | tr '\n' ' '`

@_default:
    just --list

# Build everything
build: compile autoloads

# Byte-compile all source files
compile:
    @{{batch}} --eval "(setq byte-compile-error-on-warn t)" \
    -f batch-byte-compile {{source-files}}

# Generate the autoloads file
autoloads:
    @{{batch}} --eval "(let ((out (expand-file-name \"{{pkg}}-autoloads.el\"))) \
    (cond ((require 'loaddefs-gen nil t) \
    (loaddefs-generate default-directory out)) \
    ((fboundp 'make-directory-autoloads) \
    (make-directory-autoloads default-directory out)) \
    (t (message \"Skipping autoloads: unsupported Emacs version\"))))"

# Remove all build artifacts
clean:
    @rm -f ./*.elc {{pkg}}-autoloads.el

# Run the test suite
test:
    #!/usr/bin/env bash
    set -euo pipefail
    load=""
    for file in {{test-files}}; do load="$load -l $file"; done
    {{batch}} $load -f ert-run-tests-batch-and-exit

# >>> template-rename >>>
# Rename the template: rename your-package-name
# NOTE(abi): this recipe deletes itself once you run it.
rename name:
    #!/usr/bin/env bash
    set -euo pipefail
    old_name="your-package"
    new_name="{{name}}"
    [[ "$new_name" =~ ^[a-z][a-z0-9-]*$ ]] || { echo "name must be lowercase letters, digits and hyphens" >&2; exit 1; }
    if [[ "$OSTYPE" == "darwin"* ]]; then sedi() { sed -i '' "$@"; }
    else sedi() { sed -i "$@"; }
    fi
    git mv "$old_name.el" "$new_name.el"
    if [ -f "test/$old_name-test.el" ]; then git mv "test/$old_name-test.el" "test/$new_name-test.el"; fi
    grep -rlZ --exclude-dir=.git --exclude-dir=.local-elpa -e "$old_name" -e "elisp-package-template" . \
    | xargs -0 -r sedi "s/$old_name/$new_name/g; s/elisp-package-template/$new_name/g"
    sedi '/^# >>> template-rename >>>/,/^# <<< template-rename <<<$/d' justfile
    echo "Renamed to '$new_name'.  Review the diff, then commit."
# <<< template-rename <<<
