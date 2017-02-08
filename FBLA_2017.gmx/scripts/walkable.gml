///walkable(x_pos, y_pos)

//gather arguments
var xx = argument[0];
var yy = argument[1];

//save old position
var xp = x;
var yp = y;

//move to new position
x = xx;
y = yy;

//find if bounding collisiong box overlaps a wall
var x_meeting = (Level.grid[# bbox_right div CELL_WIDTH, bbox_top div CELL_HEIGHT] == WALL) || 
                (Level.grid[# bbox_left div CELL_WIDTH, bbox_top div CELL_HEIGHT] == WALL);

var y_meeting = (Level.grid[# bbox_right div CELL_WIDTH, bbox_bottom div CELL_HEIGHT] == WALL) || 
                (Level.grid[# bbox_left div CELL_WIDTH, bbox_bottom div CELL_HEIGHT] == WALL)
        
//return to original location        
x = xp;
y = yp;

//false true if colliding
return !(x_meeting || y_meeting);

