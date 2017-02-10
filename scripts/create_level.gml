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
                //if we have a corner, then try to spawn a pickup item
                if(walls == 3) {
                    //if(irandom(odds_pickup) == odds_pickup) {
                        if(irandom(odds_coin) == odds_coin) {
                            instance_create(grid_x*CELL_WIDTH + CELL_WIDTH/2, grid_y*CELL_HEIGHT + CELL_HEIGHT/2, obj_coin);
                        } else {
                            instance_create(grid_x*CELL_WIDTH + CELL_WIDTH/2, grid_y*CELL_HEIGHT + CELL_HEIGHT/2, obj_health_pack);
                        }
                    //}
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
    audio_play_sound(snd_forest, 5, true);
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
                //if we have a corner, then try to spawn a pickup item
                if(walls == 3) {
                    if(irandom(odds_pickup) == odds_pickup) {
                        if(irandom(odds_coin) == odds_coin) {
                            instance_create(grid_x*CELL_WIDTH + CELL_WIDTH/2, grid_y*CELL_HEIGHT + CELL_HEIGHT/2, obj_coin);
                        } else {
                            instance_create(grid_x*CELL_WIDTH + CELL_WIDTH/2, grid_y*CELL_HEIGHT + CELL_HEIGHT/2, obj_health_pack);
                        }
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
    audio_play_sound(snd_mountain, 5, true);
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
    
    //chance of spike floors
    var odd_spikes = 10;
    
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
                //if we have a corner, then try to spawn a pickup item
                if(walls == 3) {
                    if(irandom(odds_pickup) == odds_pickup) {
                        if(irandom(odds_coin) == odds_coin) {
                            instance_create(grid_x*CELL_WIDTH + CELL_WIDTH/2, grid_y*CELL_HEIGHT + CELL_HEIGHT/2, obj_coin);
                        } else {
                            instance_create(grid_x*CELL_WIDTH + CELL_WIDTH/2, grid_y*CELL_HEIGHT + CELL_HEIGHT/2, obj_health_pack);
                        }
                    }
                } else {
                //or maybe we want some spiky floors?
                    if(irandom(odd_spikes) == odd_spikes) {
                        instance_create(grid_x*CELL_WIDTH + CELL_WIDTH/2, grid_y*CELL_HEIGHT + CELL_HEIGHT/2, obj_spikes);
                        if(irandom(odds_pickup) == odds_pickup) {
                            //randomly spawn an item to entice the player
                            if(irandom(odds_coin) == odds_coin) {
                                instance_create(grid_x*CELL_WIDTH + CELL_WIDTH/2, grid_y*CELL_HEIGHT + CELL_HEIGHT/2, obj_coin);
                            } else {
                                instance_create(grid_x*CELL_WIDTH + CELL_WIDTH/2, grid_y*CELL_HEIGHT + CELL_HEIGHT/2, obj_health_pack);
                            }
                        }
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
    audio_play_sound(snd_lab, 5, true);
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
    var odds_pickup = 5;
    
    //chance that a pickup will be a coin
    var odds_coin = 5;
    
    //chance of spike floors
    var odd_spikes = 5;
    
    for(var grid_y = start_y; grid_y < start_y + 5; grid_y++) {
        for(var grid_x = start_x - 1; grid_x < start_x + 1; grid_x++) {
            grid[# grid_x + 1, grid_y] = FLOOR;
        }
    }
    
    instance_create(start_x*CELL_WIDTH + CELL_WIDTH/2, (start_y + 3)*CELL_HEIGHT + CELL_HEIGHT/2, obj_boss);
    
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
                //if we have a corner, then try to spawn a pickup item
                if(walls == 3) {
                    if(irandom(odds_pickup) == odds_pickup) {
                        if(irandom(odds_coin) == odds_coin) {
                            instance_create(grid_x*CELL_WIDTH + CELL_WIDTH/2, grid_y*CELL_HEIGHT + CELL_HEIGHT/2, obj_coin);
                        } else {
                            instance_create(grid_x*CELL_WIDTH + CELL_WIDTH/2, grid_y*CELL_HEIGHT + CELL_HEIGHT/2, obj_health_pack);
                        }
                    }
                } else {
                    //or maybe we want a spiky floor?
                    if(irandom(odd_spikes) == odd_spikes) {
                        instance_create(grid_x*CELL_WIDTH + CELL_WIDTH/2, grid_y*CELL_HEIGHT + CELL_HEIGHT/2, obj_spikes);
                        //randomly create a pickup to entice the player
                        if(irandom(odds_pickup) == odds_pickup) {
                            if(irandom(odds_coin) == odds_coin) {
                                instance_create(grid_x*CELL_WIDTH + CELL_WIDTH/2, grid_y*CELL_HEIGHT + CELL_HEIGHT/2, obj_coin);
                            } else {
                                instance_create(grid_x*CELL_WIDTH + CELL_WIDTH/2, grid_y*CELL_HEIGHT + CELL_HEIGHT/2, obj_health_pack);
                            }
                        }
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
    audio_play_sound(snd_boss, 5, true);
} else if(level_num == 5) {
    //Resize the room
    room_width = CELL_WIDTH * 12;
    room_height = CELL_HEIGHT * 15;
    
    //set grid dimentions
    grid_width = room_width div CELL_WIDTH;
    grid_height = room_height div CELL_HEIGHT;
    
    start_x = 3;
    start_y = 1;
    
    instance_create(start_x*CELL_WIDTH + CELL_WIDTH/2, start_y*CELL_HEIGHT + CELL_HEIGHT/2, obj_player);
    
    //drawing out a designed tutorial level
    
    for(var grid_y = 1; grid_y < 6; grid_y++) {
        grid[# 3, grid_y] = FLOOR;
    }
    
    for(var grid_x = 2; grid_x < 11; grid_x++) {
        grid[# grid_x, 5] = FLOOR;
    }
    
    for(var grid_y = 4; grid_y < 10; grid_y++) {
        grid[# 9, grid_y] = FLOOR;
    }
    
    for(var grid_x = 1; grid_x < 10; grid_x++) {
        grid[# grid_x, 9] = FLOOR;
    }
    
    for(var grid_y = 8; grid_y < 14; grid_y++) {
        grid[# 2, grid_y] = FLOOR;
    }
    
    for(var grid_x = 2; grid_x < 12; grid_x++) {
        grid[# grid_x, 13] = FLOOR;
    }
    
    for(var grid_x = 4; grid_x < 8; grid_x++) {
        grid[# grid_x, 8] = FLOOR;
    }
    
    for(var grid_x = 4; grid_x < 8; grid_x++) {
        grid[# grid_x, 10] = FLOOR;
    }
    
    
    
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
            }
        }
    }
    
    //marking exit location
    exit_x = 11;
    exit_y = 13;
    
    //marking the exit
    grid[# exit_x, exit_y] = EXIT;
    grid[# start_x, start_y] = ENTRANCE;
    
    //position the door to the next level
    obj_door.x = exit_x*CELL_WIDTH + CELL_WIDTH/2;
    obj_door.y = exit_y*CELL_HEIGHT + CELL_HEIGHT/2;
    
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
    
    //place spikes in designated locations
    
    instance_create(5*CELL_WIDTH + CELL_WIDTH/2, 5*CELL_HEIGHT + CELL_HEIGHT/2, obj_spikes);
    
    instance_create(7*CELL_WIDTH + CELL_WIDTH/2, 5*CELL_HEIGHT + CELL_HEIGHT/2, obj_spikes);
    instance_create(8*CELL_WIDTH + CELL_WIDTH/2, 5*CELL_HEIGHT + CELL_HEIGHT/2, obj_spikes);
    
    for(var grid_x = 4; grid_x < 9; grid_x++) {
        instance_create(grid_x*CELL_WIDTH + CELL_WIDTH/2, 13*CELL_HEIGHT + CELL_HEIGHT/2, obj_spikes);
    }
    
    //place pick up items in pre-designed places
    instance_create(2*CELL_WIDTH + CELL_WIDTH/2, 5*CELL_HEIGHT + CELL_HEIGHT/2, obj_coin);
    instance_create(10*CELL_WIDTH + CELL_WIDTH/2, 5*CELL_HEIGHT + CELL_HEIGHT/2, obj_health_pack);
    instance_create(9*CELL_WIDTH + CELL_WIDTH/2, 4*CELL_HEIGHT + CELL_HEIGHT/2, obj_health_pack);
    instance_create(2*CELL_WIDTH + CELL_WIDTH/2, 8*CELL_HEIGHT + CELL_HEIGHT/2, obj_health_pack);
    instance_create(1*CELL_WIDTH + CELL_WIDTH/2, 9*CELL_HEIGHT + CELL_HEIGHT/2, obj_health_pack);
    instance_create(5*CELL_WIDTH + CELL_WIDTH/2, 13*CELL_HEIGHT + CELL_HEIGHT/2, obj_health_pack);
    instance_create(7*CELL_WIDTH + CELL_WIDTH/2, 13*CELL_HEIGHT + CELL_HEIGHT/2, obj_health_pack);
    
    //add a zombie for tutorial
    instance_create(4*CELL_WIDTH + CELL_WIDTH/2, 10*CELL_HEIGHT + CELL_HEIGHT/2, obj_zombie_2);
    
    //add objects to trigger help buttons
    for(var grid_y = 1; grid_y < 5; grid_y++) {
        instance_create(3*CELL_WIDTH + CELL_WIDTH/2, grid_y*CELL_HEIGHT + CELL_HEIGHT/2, obj_show_keys);
    }
    
    for(var grid_x = 4; grid_x < 9; grid_x++) {
        instance_create(grid_x*CELL_WIDTH + CELL_WIDTH/2, 5*CELL_HEIGHT + CELL_HEIGHT/2, obj_show_x);
        instance_create(grid_x*CELL_WIDTH + CELL_WIDTH/2, 5*CELL_HEIGHT + CELL_HEIGHT/2, obj_show_keys);
    }
    
    for(var grid_y = 8; grid_y < 11; grid_y++) {
        for(var grid_x = 3; grid_x < 10; grid_x++) {
            instance_create(grid_x*CELL_WIDTH + CELL_WIDTH/2, grid_y*CELL_HEIGHT + CELL_HEIGHT/2, obj_show_z);
        }
    }
    
}






