// routes/availableRides.js
const express = require("express");
const Ride = require("../Model/postRide.js"); // make sure path is correct
const router = express.Router();

router.get("/", async (req, res) => {
    console.log("I AM Workign");
  try {
    // Find all active rides with at least 1 available seat
    const rides = await Ride.find({
      rideStatus: "active",
      availableSeats: { $gt: 0 },
    }).sort({ departureDate: 1 }); // earliest rides first

    res.status(200).json(rides);
  } catch (err) {
    console.error("Error fetching available rides:", err);
    res.status(500).json({ error: "Server error while fetching rides" });
  }
});

module.exports = router;
