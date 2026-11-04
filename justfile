pkg := "your-package"

emacs := env_var_or_default("EMACS", "emacs")
elpa-dir  := justfile_directory() / ".local-elpa"

tools := "package-lint relint"
pkg-init := "(progn (setq package-user-dir \"" + elpa-dir + "\") (require (quote package)) (add-to-list (quote package-archives) (cons \"melpa\" \"https://melpa.org/packages/\") t) (package-initialize))"

batch  := emacs + " -Q --batch -L . -L test"
ebatch := batch + " --eval '" + pkg-init + "'"

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

# Lint against MELPA rules
lint: _tools
    @{{ebatch}} --eval "(setq package-lint-main-file \"{{pkg}}.el\")" \
    -f package-lint-batch-and-exit {{source-files}}

# Check regular expressions and docstring escapes
relint: _tools
    @{{ebatch}} -l relint -f relint-batch {{source-files}} {{test-files}}

# Install lint tooling
_tools:
    #!/usr/bin/env bash
    set -euo pipefail
    stamp="{{elpa-dir}}/.tools-installed"
    if [ -f "$stamp" ]; then exit 0; fi
    {{ebatch}} --eval '(package-refresh-contents)' \
    --eval '(dolist (p (quote ({{tools}}))) (unless (package-installed-p p) (package-install p)))'
    touch "$stamp"

# Remove all build artifacts
clean:
    @rm -f ./*.elc {{pkg}}-autoloads.el
    @rm -rf {{elpa-dir}}

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
    while IFS= read -r -d '' file; do
        sedi "s/$old_name/$new_name/g; s/elisp-package-template/$new_name/g" "$file"
    done < <(grep -rlZ --exclude-dir=.git --exclude-dir=.local-elpa -e "$old_name" -e "elisp-package-template" .)
    sedi '/^# >>> template-rename >>>/,/^# <<< template-rename <<<$/d' justfile
    echo "Renamed to '$new_name'.  Review the diff, then commit."
    # <<< template-rename <<<
