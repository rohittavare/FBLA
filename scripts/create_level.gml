///create_level(level_num)

level_num = argument[0];

//Create random seed
randomize();

if(level_num == 1) {
    //creating the starting point of the level
    start_x = irandom(grid_width - 3) + 1;
    start_y = 0;
    
    //Creating tilesetter to start of level
    var tiler_x = start_x;
    var tiler_y = start_y + 1;
    
    //Create player at center
    instance_create(start_x*CELL_WIDTH + CELL_WIDTH/2, start_y*CELL_HEIGHT + CELL_HEIGHT/2, obj_player);
    
    //Randomizing direction of tilesetter
    var tiler_dir = irandom(3);
    
    //Probility of changin direction (n = 1 gives .5)
    var prob_turn = 1;
    
    //Probability of an enemy spawn
    var prob_enemy = 30;
    
    //create a random path to the bottom of the level.
    while(tiler_y < grid_height - 1) {
         //Set current tile to FLOOR
        grid[# tiler_x, tiler_y] = FLOOR;
        
        //Move tilesetter in current direction
        tiler_x += lengthdir_x(1, tiler_dir*90);
        tiler_y += lengthdir_y(1, tiler_dir*90);
        
        //Ensure tilesetter leaves a one-unit border
        tiler_x = clamp(tiler_x, 1, grid_width - 2);
        tiler_y = clamp(tiler_y, 1, grid_height - 1);
        
        //Randomly turn the tilesetter
        if (irandom(prob_turn) == prob_turn) {
            tiler_dir = irandom(3);
        }
        
        if(point_distance(start_x, start_y, tiler_x, tiler_y) > 8 && irandom(prob_enemy) = prob_enemy) {
            instance_create(tiler_x*CELL_WIDTH + CELL_WIDTH/2, tiler_y*CELL_HEIGHT + CELL_HEIGHT/2, obj_zombie_2);
        }
    }
    
    //marking the exit
    grid[# tiler_x, tiler_y] = EXIT;
    grid[# start_x, start_y] = ENTRANCE;
    
    //marking exit location
    exit_x = tiler_x;
    exit_y = tiler_y;
    
    //create the door to the next level
    obj_door.x = exit_x*CELL_WIDTH + CELL_WIDTH/2;
    obj_door.y = exit_y*CELL_HEIGHT + CELL_HEIGHT/2;
    
    //sending tiler back to start
    tiler_x = start_x;
    tiler_y = start_y;
    
    //Create level by simulating 1000 random steps
    /*repeat(1000) {
        //Set current tile to FLOOR
        grid[# tiler_x, tiler_y] = FLOOR;
        
        //Move tilesetter in current direction
        tiler_x += lengthdir_x(1, tiler_dir*90);
        tiler_y += lengthdir_y(1, tiler_dir*90);
        
        //Ensure tilesetter leaves a one-unit border
        tiler_x = clamp(tiler_x, 1, grid_width - 2);
        tiler_y = clamp(tiler_y, 1, grid_height - 2);
        
        //Randomly turn the tilesetter
        if (irandom(prob_turn) == prob_turn) {
            tiler_dir = irandom(3);
        }
    }*/
    
    //probability of a pickup
    var odds_pickup = 2;
    
    //chance that a pickup will be a coin
    var odds_coin = 5;
    
    //Mark all void cells neighboring a floor cell as WALL
    for(var grid_y = 1; grid_y < grid_height - 1; grid_y++) {
        for(var grid_x = 1; grid_x < grid_width - 1; grid_x++) {
            if(grid[# grid_x, grid_y] == FLOOR) {
                var walls = 0;
                if(grid[# grid_x + 1, grid_y] == VOID || grid[# grid_x + 1, grid_y] == WALL) { 
                    grid[# grid_x + 1, grid_y] = WALL;
                    walls++;
                }
                if(grid[# grid_x - 1, grid_y] == VOID || grid[# grid_x - 1, grid_y] == WALL) { 
                    grid[# grid_x - 1, grid_y] = WALL;
                    walls++;
                }
                if(grid[# grid_x, grid_y + 1] == VOID || grid[# grid_x, grid_y + 1] == WALL) { 
                    grid[# grid_x, grid_y + 1] = WALL;
                    walls++;
                }
                if(grid[# grid_x, grid_y - 1] == VOID || grid[# grid_x, grid_y - 1] == WALL) { 
                    grid[# grid_x, grid_y - 1] = WALL;
                    walls++;
                }
                if(walls == 3 && irandom(odds_pickup) == odds_pickup) {
                    if(irandom(odds_coin) == odds_coin) {
                        instance_create(grid_x*CELL_WIDTH + CELL_WIDTH/2, grid_y*CELL_HEIGHT + CELL_HEIGHT/4, obj_coin);
                    } else {
                        instance_create(grid_x*CELL_WIDTH + CELL_WIDTH/2, grid_y*CELL_HEIGHT + CELL_HEIGHT/4, obj_health_pack);
                    }
                }
            }
        }
    }
    
    //Drawing tiles to screen
    for(var grid_y = 0; grid_y < grid_height; grid_y++) {
        for(var grid_x = 0; grid_x < grid_width; grid_x++) {
            if(grid[# grid_x, grid_y] == FLOOR) {
                //Draw floor
                tile_add(bg_grass, 0, 0, CELL_WIDTH, CELL_HEIGHT, grid_x*CELL_WIDTH, grid_y*CELL_HEIGHT, 1);
            }
            if(grid[# grid_x, grid_y] == WALL) {
                //Identify wall in enemy pathfinding
                mp_grid_add_cell(enemy_grid, grid_x, grid_y);
                //Draw walls
                tile_add(bg_grass, 0, 0, CELL_WIDTH, CELL_HEIGHT, grid_x*CELL_WIDTH, grid_y*CELL_HEIGHT, 1);
                /*tile_add(bg_tree, 0, 0, 108, 108, grid_x*CELL_WIDTH - 36, grid_y*CELL_HEIGHT - 70, (grid_y*CELL_HEIGHT + 17)*-1);
                tile_add(bg_tree, 0, 0, 108, 108, grid_x*CELL_WIDTH - 4, grid_y*CELL_HEIGHT - 70, (grid_y*CELL_HEIGHT + 17)*-1);
                tile_add(bg_tree, 0, 0, 108, 108, grid_x*CELL_WIDTH - 36, grid_y*CELL_HEIGHT - 38, (grid_y*CELL_HEIGHT + 49)*-1);
                tile_add(bg_tree, 0, 0, 108, 108, grid_x*CELL_WIDTH - 4, grid_y*CELL_HEIGHT - 38, (grid_y*CELL_HEIGHT + 49)*-1);
                tile_add(bg_tree_shadow, 0, 0, 108, 108, grid_x*CELL_WIDTH - 36, grid_y*CELL_HEIGHT - 70, 0);
                tile_add(bg_tree_shadow, 0, 0, 108, 108, grid_x*CELL_WIDTH - 4, grid_y*CELL_HEIGHT - 70, 0);
                tile_add(bg_tree_shadow, 0, 0, 108, 108, grid_x*CELL_WIDTH - 36, grid_y*CELL_HEIGHT - 38, 0);
                tile_add(bg_tree_shadow, 0, 0, 108, 108, grid_x*CELL_WIDTH - 4, grid_y*CELL_HEIGHT - 38, 0);*/
                //Drawing a tree and its shadow
                tile_add(bg_tree, 0, 0, 108, 108, grid_x*CELL_WIDTH - 20, grid_y*CELL_HEIGHT - 54, (grid_y*CELL_HEIGHT + 33)*-1);
                tile_add(bg_tree_shadow, 0, 0, 108, 108, grid_x*CELL_WIDTH - 20, grid_y*CELL_HEIGHT - 54, 0);
            }
            if(grid[# grid_x, grid_y] == VOID) {
                //Identify voids in enemy pathfinding
                mp_grid_add_cell(enemy_grid, grid_x, grid_y);
                //Draw voids
                //Drawing a cluster of trees to represent a thick forest
                tile_add(bg_grass, 0, 0, CELL_WIDTH, CELL_HEIGHT, grid_x*CELL_WIDTH, grid_y*CELL_HEIGHT, 1);
                tile_add(bg_tree, 0, 0, 108, 108, grid_x*CELL_WIDTH - 36, grid_y*CELL_HEIGHT - 70, (grid_y*CELL_HEIGHT + 17)*-1);
                tile_add(bg_tree, 0, 0, 108, 108, grid_x*CELL_WIDTH - 4, grid_y*CELL_HEIGHT - 70, (grid_y*CELL_HEIGHT + 17)*-1);
                tile_add(bg_tree, 0, 0, 108, 108, grid_x*CELL_WIDTH - 36, grid_y*CELL_HEIGHT - 38, (grid_y*CELL_HEIGHT + 49)*-1);
                tile_add(bg_tree, 0, 0, 108, 108, grid_x*CELL_WIDTH - 4, grid_y*CELL_HEIGHT - 38, (grid_y*CELL_HEIGHT + 49)*-1);
                tile_add(bg_tree_shadow, 0, 0, 108, 108, grid_x*CELL_WIDTH - 36, grid_y*CELL_HEIGHT - 70, 0);
                tile_add(bg_tree_shadow, 0, 0, 108, 108, grid_x*CELL_WIDTH - 4, grid_y*CELL_HEIGHT - 70, 0);
                tile_add(bg_tree_shadow, 0, 0, 108, 108, grid_x*CELL_WIDTH - 36, grid_y*CELL_HEIGHT - 38, 0);
                tile_add(bg_tree_shadow, 0, 0, 108, 108, grid_x*CELL_WIDTH - 4, grid_y*CELL_HEIGHT - 38, 0);
               
            }
            if(grid[# grid_x, grid_y] == EXIT || grid[# grid_x, grid_y] == ENTRANCE) {
                tile_add(bg_broken_tiles, 0, 0, CELL_WIDTH, CELL_HEIGHT, grid_x*CELL_WIDTH, grid_y*CELL_HEIGHT, 1);
            }
        }
    }
} else if (level_num == 2) {
    //creating the starting point of the level
    start_x = irandom(grid_width - 3) + 1;
    start_y = grid_height - 1;
    
    //Creating tilesetter to start of level
    var tiler_x = start_x;
    var tiler_y = start_y - 1;
    
    //Send player to start
    //obj_player.x = start_x + CELL_WIDTH/2;
    //obj_player.y = start_y + CELL_HEIGHT/2;
    
    instance_create(start_x*CELL_WIDTH + CELL_WIDTH/2, start_y*CELL_HEIGHT + CELL_HEIGHT/2, obj_player);
    
    //Randomizing direction of tilesetter
    var tiler_dir = irandom(3);
    
    //Probility of changin direction (n = 1 gives .5)
    var prob_turn = 1;
    
    //Probability of an enemy spawn
    var prob_enemy = 30;
    //Probability of the enemy being strong
    var prob_strong = 10;
    
    //chance that a pickup will be a coin
    var odds_coin = 20;
    
    //create a random path to the bottom of the level.
    while(tiler_y > 0) {
         //Set current tile to FLOOR
        grid[# tiler_x, tiler_y] = FLOOR;
        
        //Move tilesetter in current direction
        tiler_x += lengthdir_x(1, tiler_dir*90);
        tiler_y += lengthdir_y(1, tiler_dir*90);
        
        //Ensure tilesetter leaves a one-unit border
        tiler_x = clamp(tiler_x, 1, grid_width - 2);
        tiler_y = clamp(tiler_y, 0, grid_height - 2);
        
        //Randomly turn the tilesetter
        if (irandom(prob_turn) == prob_turn) {
            tiler_dir = irandom(3);
        }
        
        if(point_distance(start_x, start_y, tiler_x, tiler_y) > 8 && irandom(prob_enemy) = prob_enemy) {
            if(irandom(prob_strong) == prob_strong) {
                instance_create(tiler_x*CELL_WIDTH + CELL_WIDTH/2, tiler_y*CELL_HEIGHT + CELL_HEIGHT/4, obj_zombie);
            } else {
                instance_create(tiler_x*CELL_WIDTH + CELL_WIDTH/2, tiler_y*CELL_HEIGHT + CELL_HEIGHT/4, obj_zombie_2);
            }
        }
    }
    
    //marking the exit
    grid[# tiler_x, tiler_y] = EXIT;
    grid[# start_x, start_y] = ENTRANCE;
    
    //marking exit location
    exit_x = tiler_x;
    exit_y = tiler_y;
    
    //create the door to the next level
    obj_door.x = exit_x*CELL_WIDTH + CELL_WIDTH/2;
    obj_door.y = exit_y*CELL_HEIGHT + CELL_HEIGHT/2;
    
    //sending tiler back to start
    tiler_x = start_x;
    tiler_y = start_y;
    
    //Create level by simulating 1000 random steps
    /*repeat(1000) {
        //Set current tile to FLOOR
        grid[# tiler_x, tiler_y] = FLOOR;
        
        //Move tilesetter in current direction
        tiler_x += lengthdir_x(1, tiler_dir*90);
        tiler_y += lengthdir_y(1, tiler_dir*90);
        
        //Ensure tilesetter leaves a one-unit border
        tiler_x = clamp(tiler_x, 1, grid_width - 2);
        tiler_y = clamp(tiler_y, 1, grid_height - 2);
        
        //Randomly turn the tilesetter
        if (irandom(prob_turn) == prob_turn) {
            tiler_dir = irandom(3);
        }
    }*/
    
    //probability of a pickup
    var odds_pickup = 2;
    
    //chance that a pickup will be a coin
    var odds_coin = 5;
    
    //Mark all void cells neighboring a floor cell as WALL
    for(var grid_y = 1; grid_y < grid_height - 1; grid_y++) {
        for(var grid_x = 1; grid_x < grid_width - 1; grid_x++) {
            if(grid[# grid_x, grid_y] == FLOOR) {
                var walls = 0;
                if(grid[# grid_x + 1, grid_y] == VOID || grid[# grid_x + 1, grid_y] == WALL) { 
                    grid[# grid_x + 1, grid_y] = WALL;
                    walls++;
                }
                if(grid[# grid_x - 1, grid_y] == VOID || grid[# grid_x - 1, grid_y] == WALL) { 
                    grid[# grid_x - 1, grid_y] = WALL;
                    walls++;
                }
                if(grid[# grid_x, grid_y + 1] == VOID || grid[# grid_x, grid_y + 1] == WALL) { 
                    grid[# grid_x, grid_y + 1] = WALL;
                    walls++;
                }
                if(grid[# grid_x, grid_y - 1] == VOID || grid[# grid_x, grid_y - 1] == WALL) { 
                    grid[# grid_x, grid_y - 1] = WALL;
                    walls++;
                }
                if(walls == 3) {
                    if(irandom(odds_coin) == odds_coin && irandom(odds_pickup) == odds_pickup) {
                        instance_create(grid_x*CELL_WIDTH + CELL_WIDTH/2, grid_y*CELL_HEIGHT + CELL_HEIGHT/4, obj_coin);
                    } else {
                        instance_create(grid_x*CELL_WIDTH + CELL_WIDTH/2, grid_y*CELL_HEIGHT + CELL_HEIGHT/4, obj_health_pack);
                    }
                }
            }
        }
    }
    
    //Drawing tiles to screen
    for(var grid_y = 0; grid_y < grid_height; grid_y++) {
        for(var grid_x = 0; grid_x < grid_width; grid_x++) {
            if(grid[# grid_x, grid_y] == FLOOR) {
                //Draw floor
                tile_add(bg_snow, 0, 0, CELL_WIDTH, CELL_HEIGHT, grid_x*CELL_WIDTH, grid_y*CELL_HEIGHT, 1);
            }
            if(grid[# grid_x, grid_y] == WALL) {
                //Identify wall in enemy pathfinding
                mp_grid_add_cell(enemy_grid, grid_x, grid_y);
                //Draw walls
                tile_add(bg_snow, 0, 0, CELL_WIDTH, CELL_HEIGHT, grid_x*CELL_WIDTH, grid_y*CELL_HEIGHT, 1);
                tile_add(bg_rock, 0, 0, CELL_WIDTH, CELL_HEIGHT, grid_x*CELL_WIDTH, grid_y*CELL_HEIGHT, (grid_y*CELL_HEIGHT + CELL_HEIGHT)*-1);
            }
            if(grid[# grid_x, grid_y] == VOID) {
                //Identify voids in enemy pathfinding
                mp_grid_add_cell(enemy_grid, grid_x, grid_y);
                //Draw voids
                tile_add(bg_snow, 0, 0, CELL_WIDTH, CELL_HEIGHT, grid_x*CELL_WIDTH, grid_y*CELL_HEIGHT, 1);
                tile_add(bg_rock, 0, 0, CELL_WIDTH, CELL_HEIGHT, grid_x*CELL_WIDTH, grid_y*CELL_HEIGHT, (grid_y*CELL_HEIGHT + CELL_HEIGHT)*-1);
            }
            if(grid[# grid_x, grid_y] == EXIT || grid[# grid_x, grid_y] == ENTRANCE) {
                tile_add(bg_snow, 0, 0, CELL_WIDTH, CELL_HEIGHT, grid_x*CELL_WIDTH, grid_y*CELL_HEIGHT, 1);
            }
        }
    }
} else if(level_num == 3) {
    //creating the starting point of the level
    start_x = 0;
    start_y = irandom(grid_height - 3) + 1;
    
    //Creating tilesetter to start of level
    var tiler_x = start_x + 1;
    var tiler_y = start_y;
    
    //Send player to start
    //obj_player.x = start_x + CELL_WIDTH/2;
    //obj_player.y = start_y + CELL_HEIGHT/2;
    
    instance_create(start_x*CELL_WIDTH + CELL_WIDTH/2, start_y*CELL_HEIGHT + CELL_HEIGHT/2, obj_player);
    sight = instance_create(start_x*CELL_WIDTH + CELL_WIDTH/2, start_y*CELL_HEIGHT + CELL_HEIGHT/2, obj_sight);
    sight.depth = (grid_height*CELL_HEIGHT + 5)*-1;
    
    //Randomizing direction of tilesetter
    var tiler_dir = irandom(3);
    
    //Probility of changin direction (n = 1 gives .5)
    var prob_turn = 1;
    
    //Probability of an enemy spawn
    var prob_enemy = 30;
    //Probability of the enemy being strong
    var prob_strong = 10;
    
    //create a random path to the bottom of the level.
    while(tiler_x < grid_width - 1) {
         //Set current tile to FLOOR
        grid[# tiler_x, tiler_y] = FLOOR;
        
        //Move tilesetter in current direction
        tiler_x += lengthdir_x(1, tiler_dir*90);
        tiler_y += lengthdir_y(1, tiler_dir*90);
        
        //Ensure tilesetter leaves a one-unit border
        tiler_x = clamp(tiler_x, 1, grid_width - 1);
        tiler_y = clamp(tiler_y, 1, grid_height - 2);
        
        //Randomly turn the tilesetter
        if (irandom(prob_turn) == prob_turn) {
            tiler_dir = irandom(3);
        }
        
        if(point_distance(start_x, start_y, tiler_x, tiler_y) > 8 && irandom(prob_enemy) = prob_enemy) {
            if(irandom(prob_strong) == prob_strong) {
                instance_create(tiler_x*CELL_WIDTH + CELL_WIDTH/2, tiler_y*CELL_HEIGHT + CELL_HEIGHT/2, obj_zombie);
            } else {
                instance_create(tiler_x*CELL_WIDTH + CELL_WIDTH/2, tiler_y*CELL_HEIGHT + CELL_HEIGHT/2, obj_zombie_2);
            }
        }
    }
    
    //marking the exit
    grid[# tiler_x, tiler_y] = EXIT;
    grid[# start_x, start_y] = ENTRANCE;
    
    //marking exit location
    exit_x = tiler_x;
    exit_y = tiler_y;
    
    //position the door to the next level
    obj_door.x = exit_x*CELL_WIDTH + CELL_WIDTH/2;
    obj_door.y = exit_y*CELL_HEIGHT + CELL_HEIGHT/2;
    
    //sending tiler back to start
    tiler_x = start_x;
    tiler_y = start_y;
    
    //Create level by simulating 1000 random steps
    /*repeat(1000) {
        //Set current tile to FLOOR
        grid[# tiler_x, tiler_y] = FLOOR;
        
        //Move tilesetter in current direction
        tiler_x += lengthdir_x(1, tiler_dir*90);
        tiler_y += lengthdir_y(1, tiler_dir*90);
        
        //Ensure tilesetter leaves a one-unit border
        tiler_x = clamp(tiler_x, 1, grid_width - 2);
        tiler_y = clamp(tiler_y, 1, grid_height - 2);
        
        //Randomly turn the tilesetter
        if (irandom(prob_turn) == prob_turn) {
            tiler_dir = irandom(3);
        }
    }*/
    
    //probability of a pickup
    var odds_pickup = 2;
    
    //chance that a pickup will be a coin
    var odds_coin = 5;
    
    //Mark all void cells neighboring a floor cell as WALL
    for(var grid_y = 1; grid_y < grid_height - 1; grid_y++) {
        for(var grid_x = 1; grid_x < grid_width - 1; grid_x++) {
            if(grid[# grid_x, grid_y] == FLOOR) {
                var walls = 0;
                if(grid[# grid_x + 1, grid_y] == VOID || grid[# grid_x + 1, grid_y] == WALL) { 
                    grid[# grid_x + 1, grid_y] = WALL;
                    walls++;
                }
                if(grid[# grid_x - 1, grid_y] == VOID || grid[# grid_x - 1, grid_y] == WALL) { 
                    grid[# grid_x - 1, grid_y] = WALL;
                    walls++;
                }
                if(grid[# grid_x, grid_y + 1] == VOID || grid[# grid_x, grid_y + 1] == WALL) { 
                    grid[# grid_x, grid_y + 1] = WALL;
                    walls++;
                }
                if(grid[# grid_x, grid_y - 1] == VOID || grid[# grid_x, grid_y - 1] == WALL) { 
                    grid[# grid_x, grid_y - 1] = WALL;
                    walls++;
                }
                if(walls == 3) {
                    if(irandom(odds_coin) == odds_coin && irandom(odds_pickup) == odds_pickup) {
                        instance_create(grid_x*CELL_WIDTH + CELL_WIDTH/2, grid_y*CELL_HEIGHT + CELL_HEIGHT/2, obj_coin);
                    } else {
                        instance_create(grid_x*CELL_WIDTH + CELL_WIDTH/2, grid_y*CELL_HEIGHT + CELL_HEIGHT/2, obj_health_pack);
                    }
                }
            }
        }
    }
    
    //Drawing tiles to screen
    for(var grid_y = 0; grid_y < grid_height; grid_y++) {
        for(var grid_x = 0; grid_x < grid_width; grid_x++) {
            if(grid[# grid_x, grid_y] == FLOOR) {
                //Draw floor
                tile_add(bg_floor, 0, 0, CELL_WIDTH, CELL_HEIGHT, grid_x*CELL_WIDTH, grid_y*CELL_HEIGHT, 1);
            }
            if(grid[# grid_x, grid_y] == WALL) {
                //Identify wall in enemy pathfinding
                mp_grid_add_cell(enemy_grid, grid_x, grid_y);
                //Draw walls
                tile_add(bg_wall, 0, 0, CELL_WIDTH, CELL_HEIGHT + 32, grid_x*CELL_WIDTH, grid_y*CELL_HEIGHT - 32, (grid_y*CELL_HEIGHT + CELL_HEIGHT)*-1);
            }
            if(grid[# grid_x, grid_y] == VOID) {
                //Identify voids in enemy pathfinding
                mp_grid_add_cell(enemy_grid, grid_x, grid_y);
                //Draw voids
                tile_add(bg_wall, 0, 0, CELL_WIDTH, CELL_HEIGHT + 32, grid_x*CELL_WIDTH, grid_y*CELL_HEIGHT - 32, (grid_y*CELL_HEIGHT + CELL_HEIGHT)*-1);
            }
            if(grid[# grid_x, grid_y] == EXIT || grid[# grid_x, grid_y] == ENTRANCE) {
                tile_add(bg_floor, 0, 0, CELL_WIDTH, CELL_HEIGHT, grid_x*CELL_WIDTH, grid_y*CELL_HEIGHT, 1);
            }
        }
    }
} else if(level_num == 4) {
    //creating the starting point of the level
    start_x = grid_width div 2;
    start_y = grid_height div 2;
    
    //Creating tilesetter to start of level
    var tiler_x = start_x;
    var tiler_y = start_y;
    
    //Send player to start
    //obj_player.x = start_x + CELL_WIDTH/2;
    //obj_player.y = start_y + CELL_HEIGHT/2;
    
    instance_create(start_x*CELL_WIDTH + CELL_WIDTH/2, start_y*CELL_HEIGHT + CELL_HEIGHT/2, obj_player);
    
    //Randomizing direction of tilesetter
    var tiler_dir = irandom(3);
    
    //Probility of changin direction (n = 1 gives .5)
    var prob_turn = 1;
    
    //Probability of an enemy spawn
    var prob_enemy = 30;
    //Probability of the enemy being strong
    var prob_strong = 10;
    
    //Create level by simulating 1000 random steps
    repeat(1000) {
        //Set current tile to FLOOR
        grid[# tiler_x, tiler_y] = FLOOR;
        
        //Move tilesetter in current direction
        tiler_x += lengthdir_x(1, tiler_dir*90);
        tiler_y += lengthdir_y(1, tiler_dir*90);
        
        //Ensure tilesetter leaves a one-unit border
        tiler_x = clamp(tiler_x, 1, grid_width - 2);
        tiler_y = clamp(tiler_y, 1, grid_height - 2);
        
        //Randomly turn the tilesetter
        if (irandom(prob_turn) == prob_turn) {
            tiler_dir = irandom(3);
        }
    }
    
    //probability of a pickup
    var odds_pickup = 2;
    
    //chance that a pickup will be a coin
    var odds_coin = 5;
    
    for(var grid_y = start_y; grid_y < start_y + 5; grid_y++) {
        for(var grid_x = start_x - 1; grid_x < start_x + 1; grid_x++) {
            grid[# grid_x + 1, grid_y] = FLOOR;
        }
    }
    
    //Mark all void cells neighboring a floor cell as WALL
    for(var grid_y = 1; grid_y < grid_height - 1; grid_y++) {
        for(var grid_x = 1; grid_x < grid_width - 1; grid_x++) {
            if(grid[# grid_x, grid_y] == FLOOR) {
                var walls = 0;
                if(grid[# grid_x + 1, grid_y] == VOID || grid[# grid_x + 1, grid_y] == WALL) { 
                    grid[# grid_x + 1, grid_y] = WALL;
                    walls++;
                }
                if(grid[# grid_x - 1, grid_y] == VOID || grid[# grid_x - 1, grid_y] == WALL) { 
                    grid[# grid_x - 1, grid_y] = WALL;
                    walls++;
                }
                if(grid[# grid_x, grid_y + 1] == VOID || grid[# grid_x, grid_y + 1] == WALL) { 
                    grid[# grid_x, grid_y + 1] = WALL;
                    walls++;
                }
                if(grid[# grid_x, grid_y - 1] == VOID || grid[# grid_x, grid_y - 1] == WALL) { 
                    grid[# grid_x, grid_y - 1] = WALL;
                    walls++;
                }
                if(walls == 3) {
                    if(irandom(odds_coin) == odds_coin && irandom(odds_pickup) == odds_pickup) {
                        instance_create(grid_x*CELL_WIDTH + CELL_WIDTH/2, grid_y*CELL_HEIGHT + CELL_HEIGHT/2, obj_coin);
                    } else {
                        instance_create(grid_x*CELL_WIDTH + CELL_WIDTH/2, grid_y*CELL_HEIGHT + CELL_HEIGHT/2, obj_health_pack);
                    }
                }
            }
        }
    }
    
    //Drawing tiles to screen
    for(var grid_y = 0; grid_y < grid_height; grid_y++) {
        for(var grid_x = 0; grid_x < grid_width; grid_x++) {
            if(grid[# grid_x, grid_y] == FLOOR) {
                //Draw floor
                tile_add(bg_floor, 0, 0, CELL_WIDTH, CELL_HEIGHT, grid_x*CELL_WIDTH, grid_y*CELL_HEIGHT, 1);
            }
            if(grid[# grid_x, grid_y] == WALL) {
                //Identify wall in enemy pathfinding
                mp_grid_add_cell(enemy_grid, grid_x, grid_y);
                //Draw walls
                tile_add(bg_wall, 0, 0, CELL_WIDTH, CELL_HEIGHT + 32, grid_x*CELL_WIDTH, grid_y*CELL_HEIGHT - 32, (grid_y*CELL_HEIGHT + CELL_HEIGHT)*-1);
            }
            if(grid[# grid_x, grid_y] == VOID) {
                //Identify voids in enemy pathfinding
                mp_grid_add_cell(enemy_grid, grid_x, grid_y);
                //Draw voids
                tile_add(bg_wall, 0, 0, CELL_WIDTH, CELL_HEIGHT + 32, grid_x*CELL_WIDTH, grid_y*CELL_HEIGHT - 32, (grid_y*CELL_HEIGHT + CELL_HEIGHT)*-1);
            }
            if(grid[# grid_x, grid_y] == EXIT || grid[# grid_x, grid_y] == ENTRANCE) {
                tile_add(bg_floor, 0, 0, CELL_WIDTH, CELL_HEIGHT, grid_x*CELL_WIDTH, grid_y*CELL_HEIGHT, 1);
            }
        }
    }
}
