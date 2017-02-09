///move(dx, dy)

//find how much the player wants to move
var dx = argument[0];
var dy = argument[1];

//move in x position
if(walkable(x + dx, y)) {
    x += dx;
} else {
    while(walkable(x + sign(dx), y)) {
        x += sign(dx);
    }
}

//move in y position
if(walkable(x, y + dy)) {
    y += dy;
} else {
    while(walkable(x, y + sign(dy))) {
        y += sign(dy);
    }
}

