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
        // Hassad brand red, sampled from the logo circle (#df3247 = brand-500)
        brand: {
          50:  '#fdf3f4',
          100: '#fbe2e5',
          200: '#f6bfc6',
          300: '#ef929d',
          400: '#e75f70',
          500: '#df3247',
          600: '#c02337',
          700: '#9e1c2e',
          800: '#801827',
          900: '#671520',
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
