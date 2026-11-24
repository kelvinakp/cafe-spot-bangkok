const express = require('express');
const cors = require('cors');
const mysql = require('mysql2');
require('dotenv').config();

const app = express();

app.use(cors());
app.use(express.json());

const useMemory = !process.env.DATABASE_URL;
let connection = null;
let memoryCafes = [
  {
    id: 1,
    name: 'NANA Coffee Roasters',
    area: 'Ari',
    address: '24/2 Ari 4 Alley, Samsen Nai, Phaya Thai, Bangkok 10400',
    description:
      'Well-known Ari specialty cafe with garden seating and a large single-origin menu, roasted in-house.',
    image_url: 'assets/cafes/cafe1.jpg',
    vibe: 'Aesthetic',
    wifi_score: 'Great',
    signature_drink: 'Siphon Coffee',
    price_level: '฿฿฿',
    status: 'Crowded',
  },
  {
    id: 2,
    name: 'Factory Coffee',
    area: 'Phaya Thai',
    address: '49 Phaya Thai Rd, Thanon Phaya Thai, Ratchathewi, Bangkok 10400',
    description:
      'Champion barista team cafe near BTS Phaya Thai, famous for precise espresso and cold brew signatures.',
    image_url: 'assets/cafes/cafe2.jpg',
    vibe: 'Aesthetic',
    wifi_score: 'OK',
    signature_drink: 'Mrs. Cold Brew',
    price_level: '฿฿฿',
    status: 'Crowded',
  },
  {
    id: 3,
    name: 'Roots Coffee',
    area: 'Thonglor',
    address: 'theCOMMONS, Thonglor Soi 17, Watthana, Bangkok',
    description:
      'Leading Thai specialty roaster at theCOMMONS, known for supporting Thai coffee farmers and brew-bar quality.',
    image_url: 'assets/cafes/cafe3.jpg',
    vibe: 'Quiet',
    wifi_score: 'Great',
    signature_drink: 'Thai Origin Pour Over',
    price_level: '฿฿฿',
    status: 'Open',
  },
  {
    id: 4,
    name: 'Pobnar Specialty Coffee',
    area: 'Silom',
    address: 'Convent Road alley, Silom, Bang Rak, Bangkok',
    description:
      'Hidden Silom roastery with a cozy home-like feel and strong pour-over focus.',
    image_url: 'assets/cafes/cafe4.jpg',
    vibe: 'Quiet',
    wifi_score: 'OK',
    signature_drink: 'Single Origin Pour Over',
    price_level: '฿฿',
    status: 'Open',
  },
  {
    id: 5,
    name: 'La Cabra',
    area: 'Ari',
    address: 'Vanit Village, 304 Phaholyothin Rd, Phaya Thai, Bangkok',
    description:
      'Danish specialty coffee brand with Scandinavian minimal design and light-roast hand-brew options.',
    image_url: 'assets/cafes/cafe5.jpg',
    vibe: 'Aesthetic',
    wifi_score: 'OK',
    signature_drink: 'Hand-brew Filter',
    price_level: '฿฿฿',
    status: 'Open',
  },
  {
    id: 6,
    name: 'Yellow Lane Cafe',
    area: 'Ari',
    address: 'Soi Phahon Yothin 5, Phaya Thai, Bangkok 10400',
    description:
      'Popular Ari brunch cafe with garden-like seating; busy on weekends and often pet-friendly events.',
    image_url: 'assets/cafes/cafe6.jpg',
    vibe: 'Pet-friendly',
    wifi_score: 'OK',
    signature_drink: 'Brunch Latte',
    price_level: '฿฿',
    status: 'Crowded',
  },
  {
    id: 7,
    name: 'Local Boys Coffee Co.',
    area: 'Song Wat',
    address: 'Song Wat Road lane, Chakkrawat, Samphanthawong, Bangkok',
    description:
      'Industrial Song Wat specialty bar known for takeaway canned lattes in the old Chinatown riverside area.',
    image_url: 'assets/cafes/cafe7.jpg',
    vibe: 'Late-night',
    wifi_score: 'Poor',
    signature_drink: 'Canned Latte',
    price_level: '฿฿',
    status: 'Open',
  },
  {
    id: 8,
    name: 'Kaizen Coffee Co.',
    area: 'Ekkamai',
    address: 'Shop 6-7, 888 C Condo Ekamai, Sukhumvit 63, Watthana, Bangkok',
    description:
      'Ekkamai specialty cafe popular for flat whites and breakfast plates before late afternoon close.',
    image_url: 'assets/cafes/cafe8.jpg',
    vibe: 'Quiet',
    wifi_score: 'Great',
    signature_drink: 'Flat White',
    price_level: '฿฿',
    status: 'Open',
  },
];
let nextId = 9;
let memoryFavorites = [
  {
    id: 1,
    user_email: 'demo@gmail.com',
    cafe_id: 1,
    category: 'Work-friendly',
    note: 'Great garden seating for laptop work',
  },
  {
    id: 2,
    user_email: 'demo@gmail.com',
    cafe_id: 3,
    category: 'Must try',
    note: 'Best Thai origin pour over',
  },
  {
    id: 3,
    user_email: 'demo@gmail.com',
    cafe_id: 4,
    category: 'Date spot',
    note: 'Quiet and cozy alley cafe',
  },
];
let nextFavoriteId = 4;

function enrichFavorite(favorite) {
  const cafe = memoryCafes.find((item) => item.id === Number(favorite.cafe_id));
  return {
    ...favorite,
    cafe_name: cafe ? cafe.name : 'Unknown cafe',
    cafe_area: cafe ? cafe.area : '',
    cafe_image: cafe ? cafe.image_url : '',
  };
}

if (!useMemory) {
  // TiDB Cloud requires SSL. Keep ssl out of .env URL (quotes break dotenv/mysql2).
  const dbUrl = new URL(process.env.DATABASE_URL);
  connection = mysql.createConnection({
    host: dbUrl.hostname,
    port: Number(dbUrl.port || 4000),
    user: decodeURIComponent(dbUrl.username),
    password: decodeURIComponent(dbUrl.password),
    database: dbUrl.pathname.replace(/^\//, ''),
    ssl: { rejectUnauthorized: true },
  });
}



app.get('/', (req, res) => {
  res.send(
    useMemory
      ? 'Cafe Spot Bangkok API is running (memory mode)'
      : 'Cafe Spot Bangkok API is running'
  );
});

app.get('/cafes', (req, res) => {
  if (useMemory) {
    return res.send(memoryCafes);
  }
  connection.query('SELECT * FROM cafes', function (err, results) {
    if (err) {
      console.error('Error in GET /cafes:', err);
      return res.status(500).send('Error fetching cafes');
    }
    res.send(results);
  });
});

app.get('/cafes/:id', (req, res) => {
  const id = Number(req.params.id);
  if (useMemory) {
    const cafe = memoryCafes.filter((item) => item.id === id);
    return res.send(cafe);
  }
  connection.query(
    'SELECT * FROM cafes WHERE id = ?',
    [id],
    function (err, results) {
      if (err) {
        console.error('Error in GET /cafes/:id:', err);
        return res.status(500).send('Error fetching cafe');
      }
      res.send(results);
    }
  );
});

app.post('/cafes', (req, res) => {
  if (useMemory) {
    const cafe = {
      id: nextId++,
      name: req.body.name,
      area: req.body.area,
      address: req.body.address,
      description: req.body.description,
      image_url: req.body.image_url,
      vibe: req.body.vibe,
      wifi_score: req.body.wifi_score,
      signature_drink: req.body.signature_drink,
      price_level: req.body.price_level,
      status: req.body.status,
    };
    memoryCafes.push(cafe);
    return res.status(200).send({ insertId: cafe.id });
  }

  connection.query(
    'INSERT INTO `cafes` (`name`, `area`, `address`, `description`, `image_url`, `vibe`, `wifi_score`, `signature_drink`, `price_level`, `status`) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)',
    [
      req.body.name,
      req.body.area,
      req.body.address,
      req.body.description,
      req.body.image_url,
      req.body.vibe,
      req.body.wifi_score,
      req.body.signature_drink,
      req.body.price_level,
      req.body.status,
    ],
    function (err, results) {
      if (err) {
        console.error('Error in POST /cafes:', err);
        return res.status(500).send('Error adding cafe');
      }
      res.status(200).send(results);
    }
  );
});

app.put('/cafes', (req, res) => {
  if (useMemory) {
    const index = memoryCafes.findIndex((item) => item.id === Number(req.body.id));
    if (index === -1) {
      return res.status(404).send('Cafe not found');
    }
    memoryCafes[index] = {
      ...memoryCafes[index],
      name: req.body.name,
      area: req.body.area,
      address: req.body.address,
      description: req.body.description,
      image_url: req.body.image_url,
      vibe: req.body.vibe,
      wifi_score: req.body.wifi_score,
      signature_drink: req.body.signature_drink,
      price_level: req.body.price_level,
      status: req.body.status,
      id: Number(req.body.id),
    };
    return res.send({ affectedRows: 1 });
  }

  connection.query(
    'UPDATE `cafes` SET `name`=?, `area`=?, `address`=?, `description`=?, `image_url`=?, `vibe`=?, `wifi_score`=?, `signature_drink`=?, `price_level`=?, `status`=? WHERE id =?',
    [
      req.body.name,
      req.body.area,
      req.body.address,
      req.body.description,
      req.body.image_url,
      req.body.vibe,
      req.body.wifi_score,
      req.body.signature_drink,
      req.body.price_level,
      req.body.status,
      req.body.id,
    ],
    function (err, results) {
      if (err) {
        console.error('Error in PUT /cafes:', err);
        return res.status(500).send('Error updating cafe');
      }
      res.send(results);
    }
  );
});

app.delete('/cafes', (req, res) => {
  if (useMemory) {
    const before = memoryCafes.length;
    memoryCafes = memoryCafes.filter((item) => item.id !== Number(req.body.id));
    return res.send({ affectedRows: before - memoryCafes.length });
  }

  connection.query(
    'DELETE FROM `cafes` WHERE id =?',
    [req.body.id],
    function (err, results) {
      if (err) {
        console.error('Error in DELETE /cafes:', err);
        return res.status(500).send('Error deleting cafe');
      }
      res.send(results);
    }
  );
});

// Favorites CRUD (user saves cafes into categories)
app.get('/favorites', (req, res) => {
  const email = req.query.email;
  if (useMemory) {
    const rows = memoryFavorites
      .filter((item) => !email || item.user_email === email)
      .map(enrichFavorite);
    return res.send(rows);
  }

  let sql =
    'SELECT f.*, c.name AS cafe_name, c.area AS cafe_area, c.image_url AS cafe_image FROM favorites f LEFT JOIN cafes c ON f.cafe_id = c.id';
  const params = [];
  if (email) {
    sql += ' WHERE f.user_email = ?';
    params.push(email);
  }
  sql += ' ORDER BY f.id DESC';

  connection.query(sql, params, function (err, results) {
    if (err) {
      console.error('Error in GET /favorites:', err);
      return res.status(500).send('Error fetching favorites');
    }
    res.send(results);
  });
});

app.get('/favorites/:id', (req, res) => {
  const id = Number(req.params.id);
  if (useMemory) {
    const favorite = memoryFavorites.find((item) => item.id === id);
    return res.send(favorite ? [enrichFavorite(favorite)] : []);
  }

  connection.query(
    'SELECT f.*, c.name AS cafe_name, c.area AS cafe_area, c.image_url AS cafe_image FROM favorites f LEFT JOIN cafes c ON f.cafe_id = c.id WHERE f.id = ?',
    [id],
    function (err, results) {
      if (err) {
        console.error('Error in GET /favorites/:id:', err);
        return res.status(500).send('Error fetching favorite');
      }
      res.send(results);
    }
  );
});

app.post('/favorites', (req, res) => {
  if (useMemory) {
    const favorite = {
      id: nextFavoriteId++,
      user_email: req.body.user_email,
      cafe_id: Number(req.body.cafe_id),
      category: req.body.category,
      note: req.body.note,
    };
    memoryFavorites.push(favorite);
    return res.status(200).send({ insertId: favorite.id });
  }

  connection.query(
    'INSERT INTO `favorites` (`user_email`, `cafe_id`, `category`, `note`) VALUES (?, ?, ?, ?)',
    [req.body.user_email, req.body.cafe_id, req.body.category, req.body.note],
    function (err, results) {
      if (err) {
        console.error('Error in POST /favorites:', err);
        return res.status(500).send('Error adding favorite');
      }
      res.status(200).send(results);
    }
  );
});

app.put('/favorites', (req, res) => {
  if (useMemory) {
    const index = memoryFavorites.findIndex(
      (item) => item.id === Number(req.body.id)
    );
    if (index === -1) {
      return res.status(404).send('Favorite not found');
    }
    memoryFavorites[index] = {
      ...memoryFavorites[index],
      user_email: req.body.user_email,
      cafe_id: Number(req.body.cafe_id),
      category: req.body.category,
      note: req.body.note,
      id: Number(req.body.id),
    };
    return res.send({ affectedRows: 1 });
  }

  connection.query(
    'UPDATE `favorites` SET `user_email`=?, `cafe_id`=?, `category`=?, `note`=? WHERE id =?',
    [
      req.body.user_email,
      req.body.cafe_id,
      req.body.category,
      req.body.note,
      req.body.id,
    ],
    function (err, results) {
      if (err) {
        console.error('Error in PUT /favorites:', err);
        return res.status(500).send('Error updating favorite');
      }
      res.send(results);
    }
  );
});

app.delete('/favorites', (req, res) => {
  if (useMemory) {
    const before = memoryFavorites.length;
    memoryFavorites = memoryFavorites.filter(
      (item) => item.id !== Number(req.body.id)
    );
    return res.send({ affectedRows: before - memoryFavorites.length });
  }

  connection.query(
    'DELETE FROM `favorites` WHERE id =?',
    [req.body.id],
    function (err, results) {
      if (err) {
        console.error('Error in DELETE /favorites:', err);
        return res.status(500).send('Error deleting favorite');
      }
      res.send(results);
    }
  );
});

app.listen(process.env.PORT || 3000, () => {
  console.log(
    useMemory
      ? 'Cafe Spot Bangkok API listening on port 3000 (memory mode — add DATABASE_URL for TiDB)'
      : 'Cafe Spot Bangkok API listening on port 3000'
  );
});

module.exports = app;
