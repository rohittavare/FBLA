///get_boss_to_player()
//use the built in path finding
if(instance_exists(obj_player)) {
    var xx = (obj_player.x div CELL_WIDTH) *CELL_WIDTH + CELL_WIDTH/2;
    var yy = (obj_player.y div CELL_HEIGHT) *CELL_HEIGHT + CELL_HEIGHT/2;
    
    if(mp_grid_path(Level.enemy_grid, path, x, y, xx, yy, false)) {
        path_start(path, 2, path_action_stop, false);
    }
}
