import React, { useState, useEffect } from 'react';
import axios from 'axios';

function App() {
  const [message, setMessage] = useState('');
  const [loading, setLoading] = useState(false);

  // Configure axios to trust self-signed certificate
  const axiosInstance = axios.create({
    baseURL: '/api', // Proxy via Nginx
    httpsAgent: new (require('https').Agent)({
      rejectUnauthorized: false // Only for local development
    })
  });

  const fetchData = async () => {
    setLoading(true);
    try {
      const response = await axiosInstance.get('/api/hello');
      setMessage(response.data);
    } catch (error) {
      console.error('Error fetching data:', error);
      setMessage('Error connecting to backend');
    } finally {
      setLoading(false);
    }
  };

  return (
    <div style={{ padding: '20px', fontFamily: 'Arial' }}>
      <h1>React + Spring Boot Docker App</h1>
      <button 
        onClick={fetchData} 
        disabled={loading}
        style={{ padding: '10px 20px', fontSize: '16px' }}
      >
        {loading ? 'Loading...' : 'Call Backend API'}
      </button>
      {message && (
        <div style={{ marginTop: '20px', padding: '10px', background: '#f0f0f0' }}>
          <h3>Backend Response:</h3>
          <pre>{JSON.stringify(message, null, 2)}</pre>
        </div>
      )}
    </div>
  );
}

export default App;