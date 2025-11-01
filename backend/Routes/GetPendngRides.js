const express = require('express');
const router = express.Router();
const Booking = require('../Model/bookingModel.js');
const Ride = require('../Model/postRide.js');

// =======================================
// 1️⃣ Get all pending bookings for a driver
// =======================================
router.get('/:driverId', async (req, res) => {
  console.log("I AM Runnng PEnding RIde is Fetchng");
  try {
    // Find all pending bookings for this driver
    const bookings = await Booking.find({
      driverId: req.params.driverId,
      status: 'pending',
    }).populate('rideId', 'pickupLocation dropoffLocation departureDate pricePerSeat');

    if (!bookings.length) {
      return res.status(200).json({ message: 'No pending bookings found', bookings: [] });
    }

    res.status(200).json({bookings});
  } catch (err) {
    console.error('Error fetching pending bookings:', err);
    res.status(500).json({ message: 'Error fetching pending Tatty' });
  }
});

// =======================================
// 2️⃣ Accept or reject a booking request
// =======================================
router.put('/:bookingId', async (req, res) => {
  const { action } = req.body; // action: "accept" or "reject"

  try {
    const booking = await Booking.findById(req.params.bookingId);
    if (!booking) return res.status(404).json({ message: 'Booking not found' });

    booking.status = action === 'accept' ? 'accepted' : 'rejected';
    await booking.save();

    // 🪣 If accepted, update Ride seats
    if (action === 'accept') {
      await Ride.findByIdAndUpdate(booking.rideId, {
        $inc: { availableSeats: -booking.seatsBooked },
      });
    }

    res.status(200).json({
      message: `Booking ${action}ed successfully`,
      booking,
    });
  } catch (err) {
    console.error('Error updating booking status:', err);
    res.status(500).json({ message: 'Error updating booking status' });
  }
});

module.exports = router;
