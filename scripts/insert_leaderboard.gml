///insert_leaderboard(name, score)
var name = argument[0];
var scores = argument[1];

var i = 0;

while(i < 5) {
    if(board[# i, 1] < scores) {
        for(var j = 4; j > i; j--) {
            board[# j, 0] = board[# j - 1, 0];
            board[# j, 1] = board[# j - 1, 1];
        }
        board[# i, 0] = name;
        board[# i, 1] = scores;
        break;
    }
    i++;
}
