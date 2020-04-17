#!/bin/bash
set -uex

CMD="java -jar /dxWDL.jar compile $1"
shift 1

while (( "$#" )); do
  case "$1" in
    -destination)
      CMD="$CMD -destination $2"
      shift 2
      ;;
    -archive)
      case "$2" in
        "true")
          CMD="$CMD -archive"
          ;;
        "false")
          CMD="$CMD -f"
          ;;
      esac
      shift 2
      ;;
    -locked)
      case "$2" in
        "true")
          CMD="$CMD -locked"
          ;;
      esac
      shift 2
      ;;
    -streamAllFiles)
      case "$2" in
        "true")
          CMD="$CMD -streamAllFiles"
          ;;
      esac
      shift 2
      ;;
    --) # end argument parsing
      shift
      break
      ;;
    -*|--*=) # unsupported flags
      echo "Error: Unsupported flag $1" >&2
      exit 1
      ;;
    *) # preserve positional arguments
      CMD="$CMD $1"
      shift
      ;;
  esac
done

if [[ -f "extras.json" ]]; then
  CMD="$CMD -extras extras.json"
fi

workflow_id=$(eval "$CMD")
echo ::set-output name=workflow_id::"$workflow_id"
