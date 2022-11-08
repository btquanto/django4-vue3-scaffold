
if [[ -z $APP ]] || [[ ! "yarn app node docker init" =~ "$APP" ]]; then
  cat _documents/help_content.md;
  return;
fi