CREATE TABLE `cafes` (
  `id` int(11) PRIMARY KEY AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `area` varchar(255) NOT NULL,
  `address` text NOT NULL,
  `description` text NOT NULL,
  `image_url` text NOT NULL,
  `vibe` varchar(100) NOT NULL,
  `wifi_score` varchar(50) NOT NULL,
  `signature_drink` varchar(255) NOT NULL,
  `price_level` varchar(10) NOT NULL,
  `status` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `favorites` (
  `id` int(11) PRIMARY KEY AUTO_INCREMENT,
  `user_email` varchar(255) NOT NULL,
  `cafe_id` int(11) NOT NULL,
  `category` varchar(100) NOT NULL,
  `note` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

INSERT INTO `cafes`
(`name`, `area`, `address`, `description`, `image_url`, `vibe`, `wifi_score`, `signature_drink`, `price_level`, `status`)
VALUES
('NANA Coffee Roasters', 'Ari', '24/2 Ari 4 Alley, Samsen Nai, Phaya Thai, Bangkok 10400', 'Well-known Ari specialty cafe with garden seating and a large single-origin menu, roasted in-house.', 'assets/cafes/cafe1.jpg', 'Aesthetic', 'Great', 'Siphon Coffee', '฿฿฿', 'Crowded'),
('Factory Coffee', 'Phaya Thai', '49 Phaya Thai Rd, Thanon Phaya Thai, Ratchathewi, Bangkok 10400', 'Champion barista team cafe near BTS Phaya Thai, famous for precise espresso and cold brew signatures.', 'assets/cafes/cafe2.jpg', 'Aesthetic', 'OK', 'Mrs. Cold Brew', '฿฿฿', 'Crowded'),
('Roots Coffee', 'Thonglor', 'theCOMMONS, Thonglor Soi 17, Watthana, Bangkok', 'Leading Thai specialty roaster at theCOMMONS, known for supporting Thai coffee farmers and brew-bar quality.', 'assets/cafes/cafe3.jpg', 'Quiet', 'Great', 'Thai Origin Pour Over', '฿฿฿', 'Open'),
('Pobnar Specialty Coffee', 'Silom', 'Convent Road alley, Silom, Bang Rak, Bangkok', 'Hidden Silom roastery with a cozy home-like feel and strong pour-over focus.', 'assets/cafes/cafe4.jpg', 'Quiet', 'OK', 'Single Origin Pour Over', '฿฿', 'Open'),
('La Cabra', 'Ari', 'Vanit Village, 304 Phaholyothin Rd, Phaya Thai, Bangkok', 'Danish specialty coffee brand with Scandinavian minimal design and light-roast hand-brew options.', 'assets/cafes/cafe5.jpg', 'Aesthetic', 'OK', 'Hand-brew Filter', '฿฿฿', 'Open'),
('Yellow Lane Cafe', 'Ari', 'Soi Phahon Yothin 5, Phaya Thai, Bangkok 10400', 'Popular Ari brunch cafe with garden-like seating; busy on weekends and often pet-friendly events.', 'assets/cafes/cafe6.jpg', 'Pet-friendly', 'OK', 'Brunch Latte', '฿฿', 'Crowded'),
('Local Boys Coffee Co.', 'Song Wat', 'Song Wat Road lane, Chakkrawat, Samphanthawong, Bangkok', 'Industrial Song Wat specialty bar known for takeaway canned lattes in the old Chinatown riverside area.', 'assets/cafes/cafe7.jpg', 'Late-night', 'Poor', 'Canned Latte', '฿฿', 'Open'),
('Kaizen Coffee Co.', 'Ekkamai', 'Shop 6-7, 888 C Condo Ekamai, Sukhumvit 63, Watthana, Bangkok', 'Ekkamai specialty cafe popular for flat whites and breakfast plates before late afternoon close.', 'assets/cafes/cafe8.jpg', 'Quiet', 'Great', 'Flat White', '฿฿', 'Open');

INSERT INTO `favorites` (`user_email`, `cafe_id`, `category`, `note`)
VALUES
('demo@gmail.com', 1, 'Work-friendly', 'Great place to save for later'),
('demo@gmail.com', 3, 'Must try', 'Best specialty coffee stop'),
('demo@gmail.com', 4, 'Date spot', 'Quiet and cozy');
