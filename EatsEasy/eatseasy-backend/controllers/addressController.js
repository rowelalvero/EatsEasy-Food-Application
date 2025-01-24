const Address = require('../models/Address')
const User = require('../models/User')
const axios = require('axios');

module.exports = {
    getPolyline: async (req, res) => {
        const { originLat, originLng, destinationLat, destinationLng, googleApiKey } = req.body;

        const googleApiUrl = `https://maps.googleapis.com/maps/api/directions/json?origin=${originLat},${originLng}&destination=${destinationLat},${destinationLng}&key=${googleApiKey}&mode=driving&optimizeWaypoints=true`;

        try {
          const response = await axios.get(googleApiUrl);

          if (response.data.routes && response.data.routes.length > 0) {
            const route = response.data.routes[0];
            const polyline = route.overview_polyline.points;

            // Decode polyline on the server
            const decodedPolyline = decodePolyline(polyline);

            res.status(200).json({
              status: true,
              polyline: decodedPolyline, // Send back decoded points
            });
          } else {
            res.status(404).json({ status: false, message: 'No routes found' });
          }
        } catch (error) {
          console.error('Error fetching polyline:', error);
          res.status(500).json({ status: false, message: error.message });
        }
      },

    getDirections: async (req, res) => {
        const { originLat, originLng, destinationLat, destinationLng, googleApiKey } = req.body;

        const origin = `${originLat},${originLng}`;
        const destination = `${destinationLat},${destinationLng}`;
        const googleApiUrl = `https://maps.googleapis.com/maps/api/directions/json?origin=${origin}&destination=${destination}&key=${googleApiKey}`;

        try {
            // Call the Google Maps API via a backend proxy (avoiding CORS)
            const response = await axios.get(googleApiUrl);

            if (response.data.routes && response.data.routes.length > 0) {
                const route = response.data.routes[0];
                const leg = route.legs[0];

                const distance = leg.distance.value / 1000; // in kilometers
                const duration = leg.duration.value / 60; // in minutes

                // Send back the distance and duration
                res.status(200).json({
                    status: true,
                    distance: distance,
                    duration: duration
                });
            } else {
                res.status(404).json({ status: false, message: 'No routes found' });
            }
        } catch (error) {
            console.error('Error fetching directions:', error);
            res.status(500).json({ status: false, message: error.message });
        }
    },

    searchPlaces: async (req, res) => {
        const { searchQuery, googleApiKey } = req.body;

        try {
          const url = `https://maps.googleapis.com/maps/api/place/autocomplete/json?input=${encodeURIComponent(searchQuery)}&key=${googleApiKey}`;
          const response = await axios.get(url);

          if (response.status === 200) {
            res.status(200).json({
              status: true,
              predictions: response.data.predictions
            });
          } else {
            res.status(404).json({ status: false, message: 'No results found' });
          }
        } catch (error) {
          console.error('Error fetching places:', error);
          res.status(500).json({ status: false, message: error.message });
        }
      },

    getPlaceDetail: async (req, res) => {
        const { placeId, googleApiKey } = req.body;

        try {
          const url = `https://maps.googleapis.com/maps/api/place/details/json?place_id=${placeId}&key=${googleApiKey}`;
          const response = await axios.get(url);

          if (response.status === 200) {
            const placeDetail = response.data.result;

            // Extract latitude, longitude, address, and postal code
            const lat = placeDetail.geometry.location.lat;
            const lng = placeDetail.geometry.location.lng;
            const address = placeDetail.formatted_address;
            let postalCode = '';

            placeDetail.address_components.forEach((component) => {
              if (component.types.includes('postal_code')) {
                postalCode = component.long_name;
              }
            });

            res.status(200).json({
              status: true,
              lat,
              lng,
              address,
              postalCode,
            });
          } else {
            res.status(404).json({ status: false, message: 'Place not found' });
          }
        } catch (error) {
          console.error('Error fetching place details:', error);
          res.status(500).json({ status: false, message: error.message });
        }
      },

    reverseGeocode: async (req, res) => {
      const { lat, lng, googleApiKey } = req.body;

      try {
        const url = `https://maps.googleapis.com/maps/api/geocode/json?latlng=${lat},${lng}&key=${googleApiKey}`;
        const response = await axios.get(url);

        if (response.status === 200 && response.data.results.length > 0) {
          const address = response.data.results[0].formatted_address;
          let postalCode = '';

          response.data.results[0].address_components.forEach((component) => {
            if (component.types.includes('postal_code')) {
              postalCode = component.long_name;
            }
          });

          res.status(200).json({
            status: true,
            address,
            postalCode,
          });
        } else {
          res.status(404).json({ status: false, message: 'Address not found' });
        }
      } catch (error) {
        console.error('Error during reverse geocoding:', error);
        res.status(500).json({ status: false, message: error.message });
      }
    },

    createAddress: async (req, res) => {

        const address = new Address({
            addressName: req.body.addressName,
            userId: req.user.id,
            addressLine1: req.body.addressLine1,
            postalCode: req.body.postalCode,
            default: req.body.default,
            deliveryInstructions: req.body.deliveryInstructions,
            latitude: req.body.latitude,
            longitude: req.body.longitude
        });

        try {
            if (req.body.default === true) {
                // Ensure no other address is set as default for this user
                await Address.updateMany({ userId: req.user.id }, { default: false });
            }
            await address.save();
            res.status(201).json({ status: true, message: 'Address successfully added' });
        } catch (error) {
            res.status(500).json({ status: false, message: error.message });
        }
    },

    setDefaultAddress: async (req, res) => {
        const userId = req.user.id;
        const addressId = req.params.address;

        try {
            // Set all addresses for this user to non-default
            await Address.updateMany({ userId: userId }, { default: false });

            // Now set the specified address as default
            const updatedAddress = await Address.findByIdAndUpdate(addressId, { default: true }, { new: true });

            if (updatedAddress) {
                // Update the user's address field to the new default address
                await User.findByIdAndUpdate(userId, { address: addressId }, { new: true });

                res.status(200).json({ status: true, message: 'Address set as default successfully' });
            } else {
                res.status(404).json({ status: false, message: 'Address not found' });
            }
        } catch (error) {
            res.status(500).json({ status: false, message: error.message });
        }
    },

    deleteAddress: async (req, res) => {
        const addressId = req.params.id;

        try {
            await Address.findByIdAndDelete(addressId);
            res.status(200).json({ status: true, message: 'Address deleted successfully' });
        } catch (error) {
            res.status(500).json(error);
        }
    },

    getDefaultAddress: async (req, res) => {
        const userId = req.user.id;

        try {
            const defaultAddress = await Address.findOne({ userId, default: true });
            res.status(200).json(defaultAddress);
        } catch (error) {
            res.status(500).json(error);
        }
    },

    getUserAddresses: async (req, res) => {
        const userId = req.user.id;


        try {
            const addresses = await Address.find({ userId });
            res.status(200).json(addresses);
        } catch (error) {
            res.status(500).json({ status: false, message: error.message });
        }
    },

    updateAddress: async (req, res) => {
        const addressId = req.params.id;


        try {
            if (req.body.default === true) {
                // Ensure no other address is set as default for this user
                await Address.updateMany({ userId: req.body.userId }, { default: false });
            }
            await Address.findByIdAndUpdate(addressId, req.body, { new: true });
            res.status(200).json({ status: true, message: 'Address updated successfully' });
        } catch (error) {
            res.status(500).json(error);
        }
    },

};

function decodePolyline(encoded) {
  const points = [];
  let index = 0, lat = 0, lng = 0;

  while (index < encoded.length) {
    let shift = 0, result = 0, b;
    do {
      b = encoded.charCodeAt(index++) - 63;
      result |= (b & 0x1f) << shift;
      shift += 5;
    } while (b >= 0x20);

    const dLat = (result & 1) !== 0 ? ~(result >> 1) : (result >> 1);
    lat += dLat;

    shift = 0;
    result = 0;
    do {
      b = encoded.charCodeAt(index++) - 63;
      result |= (b & 0x1f) << shift;
      shift += 5;
    } while (b >= 0x20);

    const dLng = (result & 1) !== 0 ? ~(result >> 1) : (result >> 1);
    lng += dLng;

    points.push({ latitude: lat / 1e5, longitude: lng / 1e5 });
  }

  return points;
}