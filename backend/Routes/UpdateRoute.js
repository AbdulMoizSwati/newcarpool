const express = require("express");
const router = express.Router();
const User = require("../Model/LoginModel.js");

// ✅ GET - fetch user profile
router.get("/:userId", async (req, res) => {
  try {
    const userId = req.params.userId;
    const user = await User.findById(userId);

    if (!user) {
      return res.status(404).json({ error: "User not found" });
    }

    // Exclude password
    const { password, ...userData } = user._doc;

    res.status(200).json(userData);
  } catch (err) {
    console.error("Error fetching user profile:", err);
    res.status(500).json({ error: "Server error" });
  }
});

// ✅ PUT - update user profile
router.put("/:userId", async (req, res) => {
  try {
    const userId = req.params.userId;
    const updatedData = req.body;

    if (!updatedData.name || !updatedData.email || !updatedData.contact) {
      return res.status(400).json({ error: "Required fields missing" });
    }

    const user = await User.findByIdAndUpdate(userId, updatedData, {
      new: true,
    });

    if (!user) return res.status(404).json({ error: "User not found" });

    res.status(200).json({ message: "Profile updated successfully", user });
  } catch (err) {
    console.error("Profile update error:", err);
    res.status(500).json({ error: "Server error" });
  }
});

module.exports = router;
