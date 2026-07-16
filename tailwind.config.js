/** @type {import('tailwindcss').Config} */
module.exports = {
  content: ['./index.html'],
  theme: {
    extend: {
      fontFamily: {
        sans:    ['Inter', 'Cairo', 'system-ui', 'sans-serif'],
        display: ['Fraunces', 'Cairo', 'Georgia', 'serif'],
      },
      colors: {
        brand: {
          50:  '#fbf6ef',
          100: '#f4e8d4',
          200: '#e8d2ab',
          300: '#dbb87e',
          400: '#c99455',
          500: '#a87035',
          600: '#8a5729',
          700: '#6e4220',
          800: '#573419',
          900: '#422813',
        },
        accent: { 500: '#c44a4a', 600: '#a93838', 700: '#8c2929' },
      },
      boxShadow: {
        card: '0 1px 2px rgba(15,23,42,.06), 0 1px 3px rgba(15,23,42,.08)',
        pop:  '0 10px 30px rgba(15,23,42,.16)',
      },
    },
  },
  plugins: [],
};
