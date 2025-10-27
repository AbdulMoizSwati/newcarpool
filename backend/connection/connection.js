const mongoose = require("mongoose");

function Connect(){
mongoose.connect("mongodb://localhost:27017/Nodecarpoll").then(()=>{
    console.log("Mongo Db is Connected Sucessfully");
}).catch((err)=>{
    console.log(`error of connection databse ${err}`)
});
}

module.exports = Connect;
