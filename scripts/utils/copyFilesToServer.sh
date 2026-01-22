copyFilesToServer() {
  : "${FILES_TO_COPY:?FILES_TO_COPY is not set}"
  : "${SERVER_USER:?SERVER_USER is not set}"
  : "${SERVER_HOST:?SERVER_HOST is not set}"
  : "${TARGET_DIR:?TARGET_DIR is not set}"

  for FILE in "${FILES_TO_COPY[@]}"; do
    DIR_ON_SERVER=$(dirname "$FILE")
    ssh "$SERVER_USER@$SERVER_HOST" "mkdir -p \"$TARGET_DIR/$DIR_ON_SERVER\""
    if [ -d "$FILE" ]; then
      # directory
      ssh "$SERVER_USER@$SERVER_HOST" "mkdir -p \"$TARGET_DIR/$FILE\""
      scp -r "$FILE/"* "$SERVER_USER@$SERVER_HOST:$TARGET_DIR/$FILE/"
    else
      # file
      DIR_ON_SERVER=$(dirname "$FILE")
      ssh "$SERVER_USER@$SERVER_HOST" "mkdir -p \"$TARGET_DIR/$DIR_ON_SERVER\""
      scp -r "$FILE" "$SERVER_USER@$SERVER_HOST:$TARGET_DIR/$FILE"
    fi
  done
}
