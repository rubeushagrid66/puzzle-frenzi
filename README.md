# Puzzle Frenzi

Game match-3 Enzi — **Puzzle Frenzi**. Candy Crush-like, tapi itemnya komponen alat dari video Enzilektual.

Live: https://puzzle-frenzi.vercel.app

## Cara main

- Tukar 2 tile bersebelahan (vertikal / horizontal saja, **tanpa diagonal**) untuk membuat 3+ item sebaris.
- Kejar target tiap level sebelum timer habis (timer keras — waktu habis = ulang level).
- 10 level: Kompor Induksi, Kipas Angin, Kulkas, Pompa Filter Kolam, Proyektor Bioskop, Pistol Air, Microwave, Mesin Cuci, Rice Cooker, Setrika.
- Tiap level selesai ada popup 1 komponen penting alat itu + kuis klaim hadiah (jawabannya cuma ada di video full-nya).
- Tombol **Minta Waktu** (maks 2x/level): pilihan ganda +8 detik, ketik jawaban +12 detik. Timer jeda selama kuis.
- Pangkat: Pemula → Tau → Serba Bisa. Tamat semua level: sertifikat **Teman Intelektual** + vote alat berikutnya.
- Hadiah tanpa modal: badge, stiker Enzi, kartu skor share, catatan rahasia.

## Tech stack

- **Statis, tanpa build step**: `index.html` + CSS/JS inline (mobile-first).
- **Mobile-first**: board max 520px di HP; di desktop (≥768px) game tampil sebagai kolom selebar HP (480px) di tengah dengan backdrop arcade gelap — tidak pernah full width.
- **Progress**: `localStorage` (`enzi-match3-progress-v2`) sebagai source of truth offline.
- **Supabase** (opsional, best-effort): sync progress + leaderboard + vote, lewat `js/supabase-config.js`. Kalau config kosong, game jalan penuh offline.

## Supabase setup

1. Buat project baru di Supabase dengan akun **naimybinomo2@gmail.com** (akun amy.superant sudah penuh project-nya). Nama project: `puzzle-frenzi`, region: Singapore (ap-southeast-1).
2. Di SQL Editor, jalankan `supabase/schema.sql` (tabel `player_progress`, `leaderboard`, `level_votes` + RLS).
3. Salin Project URL + anon key dari Settings → API ke `js/supabase-config.js` (dan ke Vercel env kalau nanti dipakai server-side).
4. Deploy ulang — sync jalan otomatis tiap 8 detik saat main.

## Deploy (Vercel)

- Repo: `rubeushagrid66/puzzle-frenzi`, branch `main`, root `index.html`.
- Vercel project: `puzzle-frenzi` → https://puzzle-frenzi.vercel.app
- Framework preset: Other / static. Tidak ada build command.

## Struktur

```
index.html               # game lengkap (single file, aset inline)
js/supabase-config.js    # URL + anon key Supabase (isi setelah project dibuat)
supabase/schema.sql      # tabel + RLS, jalankan di SQL Editor
vercel.json              # cleanUrls + security headers
```

## Catatan

- Prototipe puzzle lama (Bengkel Enzi) tidak diubah — ini repo/produk terpisah.
- Karakter memakai gambar referensi dan stiker Enzi asli apa adanya.
