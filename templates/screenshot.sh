OUTPUT_FILE="comment.md"

append() {
    echo "$1" >> "$OUTPUT_FILE"
}

add_screenshots() {
    local prefix="$1"
    local title="$2"

    append ""
    append "#### $title"

    for ss in "$ss_test"*${prefix}*.png; do
        [ -e "$ss" ] || continue
        append '<p float="left">'
        append "  $ss"
        cml-publish "$ss" | sed -E 's/.+/<img width="90%" src="\0"\/>/' >> "$OUTPUT_FILE"
        append '</p>'
    done
}

append "# 📷 Screenshots of tests:"
append ""

for ss_test in logs/**/; do
    ss_test_desc=$(basename "$ss_test" .png)

    [ "$ss_test_desc" != "test-reports" ] || continue

    append ""
    append "### 🔧 $ss_test_desc"
    append ""

    add_screenshots "Pre" "Pre Test"
    add_screenshots "Post" "Post Test"

    append ""
done

case "$EVENT" in
    pull_request)    sha="$PULL_REQUEST_HEAD_SHA" ;;
    workflow_run)    sha="$WORKFLOW_RUN_HEAD_SHA" ;;
    *)               sha="$GITHUB_SHA" ;;
esac

append ""
append "###### For commit $sha"
