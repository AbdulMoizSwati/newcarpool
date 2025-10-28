const express = require("express");
const bcrypt = require("bcrypt");
const jwt = require("jsonwebtoken");
const User = require("../Model/LoginModel.js");

const loginRouter = express.Router();

loginRouter.post("/", async (req, res) => {
  const { email, password } = req.body;

  console.log(`Login attempt -> Email: ${email} | Password: ${password}`);

  if (!email || !password) {
    return res.status(400).json({ success: false, message: "Empty fields!" });
  }

  try {
    const user = await User.findOne({ email: email });

    if (!user) {
      return res.status(404).json({ success: false, message: "User not found!" });
    }

    // Compare password
    const isMatch = await bcrypt.compare(password, user.password);
    if (!isMatch) {
      return res.status(401).json({ success: false, message: "Invalid password!" });
    }

    // ✅ Generate JWT token (valid for 7 days)
    const token = jwt.sign(
      {
        id: user._id,
        role: user.role,
        email: user.email,
      },
      "1234", // hardcoded secret key
      { expiresIn: "7d" }
    );

    console.log("✅ User logged in successfully");

    // ✅ Send response to Flutter
    return res.status(200).json({
      success: true,
      message: "Login successful!",
      token: token,
      user: {
        id: user._id,
        name: user.name,
        email: user.email,
        role: user.role,
      },
    });
  } catch (err) {
    console.error("❌ Login error:", err);
    return res.status(500).json({ success: false, message: "Server error!" });
  }
});

module.exports = loginRouter;
