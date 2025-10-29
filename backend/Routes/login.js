const express = require("express");
const bcrypt = require("bcrypt");
const jwt = require("jsonwebtoken");
const User = require("../Model/LoginModel.js");

const loginRouter = express.Router();

loginRouter.post("/", async (req, res) => {
  const { email, password } = req.body;

  console.log(`🔐 Login attempt -> Email: ${email}`);

  if (!email || !password) {
    return res.status(400).json({ success: false, message: "Email and password required!" });
  }

  try {
    const user = await User.findOne({ email });

    if (!user) {
      return res.status(404).json({ success: false, message: "User not found!" });
    }

    // Compare password using bcrypt
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
      "1234", // 🔒 Ideally move this secret to .env
      { expiresIn: "7d" }
    );

    console.log("✅ User logged in successfully");

    // ✅ Prepare user details to send back
    const userData = {
      id: user._id,
      name: user.name,
      email: user.email,
      age: user.age,
      gender: user.gender,
      contact: user.contact,
      idCard: user.idCard,
      profileImagePath: user.profileImagePath || "",
      role: user.role,
      carDetails: user.carDetails
        ? {
            carType: user.carDetails.carType,
            carNumber: user.carDetails.carNumber,
            licenseNumber: user.carDetails.licenseNumber,
          }
        : null,
      createdAt: user.createdAt,
      updatedAt: user.updatedAt,
    };

    // ✅ Send response
    return res.status(200).json({
      success: true,
      message: "Login successful!",
      token,
      user: userData,
    });
  } catch (err) {
    console.error("❌ Login error:", err);
    return res.status(500).json({
      success: false,
      message: "Internal server error",
      error: err.message,
    });
  }
});

module.exports = loginRouter;
