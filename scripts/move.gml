///move(dx, dy)

var dx = argument[0];
var dy = argument[1];

if(walkable(x + dx, y)) {
    x += dx;
} else {
    while(walkable(x + sign(dx), y)) {
        x += sign(dx);
    }
}


if(walkable(x, y + dy)) {
    y += dy;
} else {
    while(walkable(x, y + sign(dy))) {
        y += sign(dy);
    }
}

