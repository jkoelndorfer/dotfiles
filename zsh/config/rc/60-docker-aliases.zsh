function dsh() {
    local selected_container=$(docker ps | fzf --header-lines=1 | awk '{ print $1 }')
    docker exec -it "$selected_container" bash
}
