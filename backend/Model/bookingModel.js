const mongoose = require('mongoose');

const bookingSchema = new mongoose.Schema(
  {
    // 🔗 Link to the ride
    rideId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'Ride',
      required: true,
    },

    // 🧑‍✈️ Driver info (redundant but useful for quick lookups)
    driverId: {
      type: String,
      required: true,
    },
    driverName: {
      type: String,
      required: true,
    },

    // 🚖 Passenger info
    passengerId: {
      type: String,
      required: true,
    },
    passengerName: {
      type: String,
      required: true,
    },

    // 💺 Seats booked
    seatsBooked: {
      type: Number,
      required: true,
      min: 1,
    },

    // 💰 Payment or price info (optional, from ride)
    pricePerSeat: {
      type: Number,
      required: true,
      min: 0,
    },

    // 🕓 Booking status
    status: {
      type: String,
      enum: ['pending', 'accepted', 'rejected', 'cancelled'],
      default: 'pending',
    },

    // 📅 Optional: to track if passenger attended the ride or not
    rideCompleted: {
      type: Boolean,
      default: false,
    },
  },
  { timestamps: true }
);

const Booking = mongoose.model('Booking', bookingSchema);
module.exports = Booking;
