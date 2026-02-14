const express = require('express');
const cors = require('cors');
require('dotenv').config();

const app = express();
const PORT = process.env.PORT || 5000;

// Middleware
app.use(cors());
app.use(express.json());

// Mock data for boardinghouses (in a real app, this would come from your database)
const boardinghouses = [
  {
    id: '1',
    title: 'Cozy Downtown Studio',
    description: 'Comfortable studio in the heart of the city',
    price: 8500.00,
    location: 'Poblacion, Tagoloan',
    images: ['https://example.com/image1.jpg'],
    amenities: ['Wi-Fi', 'Aircon'],
    latitude: 8.4871,
    longitude: 124.6271,
    roomType: 'Studio',
    contactNumber: '+639123456789',
    rating: 4.5,
    reviewCount: 12
  },
  {
    id: '2',
    title: 'Modern Living Quarters',
    description: 'Modern apartment with great amenities',
    price: 12000.00,
    location: 'Natumolan, Tagoloan',
    images: ['https://example.com/image2.jpg'],
    amenities: ['Wi-Fi', 'Aircon', 'Kitchen'],
    latitude: 8.4865,
    longitude: 124.6285,
    roomType: '1 Bedroom',
    contactNumber: '+639123456790',
    rating: 4.7,
    reviewCount: 8
  }
];

// Route to get map data for a specific boardinghouse (securely handles API key)
app.get('/api/boardinghouse/:id/map-data', async (req, res) => {
  try {
    const { id } = req.params;
    
    // Find the boardinghouse
    const boardinghouse = boardinghouses.find(b => b.id === id);
    
    if (!boardinghouse) {
      return res.status(404).json({ error: 'Boardinghouse not found' });
    }

    // Return only the map-related data (coordinates, location info)
    // The actual Google Maps API calls happen server-side if needed
    const mapData = {
      id: boardinghouse.id,
      title: boardinghouse.title,
      location: boardinghouse.location,
      latitude: boardinghouse.latitude,
      longitude: boardinghouse.longitude,
      // Optionally, you could generate a static map URL server-side
      staticMapUrl: `https://maps.googleapis.com/maps/api/staticmap?center=${boardinghouse.latitude},${boardinghouse.longitude}&zoom=15&size=600x400&key=${process.env.GOOGLE_MAPS_API_KEY}`,
      // Or return directions if needed
      directions: {
        origin: 'current_location', // This would be provided by the client
        destination: {
          lat: boardinghouse.latitude,
          lng: boardinghouse.longitude,
          address: boardinghouse.location
        }
      }
    };

    res.json(mapData);
  } catch (error) {
    console.error('Error fetching map data:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// Route to get nearby places (another secure endpoint)
app.get('/api/nearby-places/:id', async (req, res) => {
  try {
    const { id } = req.params;
    const { radius = 1000 } = req.query; // Default radius 1km
    
    // Find the boardinghouse
    const boardinghouse = boardinghouses.find(b => b.id === id);
    
    if (!boardinghouse) {
      return res.status(404).json({ error: 'Boardinghouse not found' });
    }

    // In a real app, you'd call Google Places API server-side here
    // For demo purposes, returning mock nearby places
    const nearbyPlaces = [
      {
        name: 'Tagoloan Municipal Hall',
        vicinity: 'Poblacion, Tagoloan',
        distance: 0.3,
        type: 'government_office',
        lat: boardinghouse.latitude + 0.001,
        lng: boardinghouse.longitude - 0.001
      },
      {
        name: 'Tagoloan Market',
        vicinity: 'Poblacion, Tagoloan',
        distance: 0.5,
        type: 'store',
        lat: boardinghouse.latitude - 0.001,
        lng: boardinghouse.longitude + 0.001
      }
    ];

    res.json(nearbyPlaces);
  } catch (error) {
    console.error('Error fetching nearby places:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// Health check endpoint
app.get('/health', (req, res) => {
  res.json({ status: 'OK', timestamp: new Date().toISOString() });
});

app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
  console.log(`API endpoints available at http://localhost:${PORT}`);
});