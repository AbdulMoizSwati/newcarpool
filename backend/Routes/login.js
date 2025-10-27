const express = require("express");
const bcrypt = require("bcrypt");
const User = require("../Model/LoginModel.js");


const loginRouter = express.Router();
console.log("User Route Is Hitting");

loginRouter.post("/",async (req,res)=>{

    const{email,password} = req.body;

    console.log(`Name is ${email} and Password is ${password}`);

    if(!email || !password){
        return res.status(400).json({error : "Empty Fields"});
    }

    try{
        console.log(`Name is ${email} and Password is ${password}`);
        const user =await User.findOne({email: email});
        if(!user){
            return res.status(404).json({ error: "User not found!" });
        }
    // compare Passwords
    const isMatch = await bcrypt.compare(password, user.password);
    if (!isMatch) {
      return res.status(401).json({ error: "Invalid password!" });
    }
     return res.status(200).json({
      message: "Login successful!",
      userId: user._id,
      role: user.role,
      name: user.name,
    });
    }catch(err){
         console.error("Login error:", err);
    return res.status(500).json({ error: "Server error" });
  
    }
    




})

module.exports = loginRouter;
