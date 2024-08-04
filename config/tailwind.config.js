const defaultTheme = require('tailwindcss/defaultTheme')
const colors = require('tailwindcss/colors')


module.exports = {
  content: [
    './app/helpers/**/*.rb',
    './app/javascript/**/*.js',
    './app/views/**/*'
  ],
  theme: {
    extend: {
      backgroundImage: {
        'group': "url('app/assets/images/group.png')",
      },
      fontFamily: {
        sans: ['Inter var', ...defaultTheme.fontFamily.sans]
      },
      // custom color palette for branding, see https://tailwindcss.com/docs/customizing-colors
      backgroundColor: {
        'brand-teal': '#BECDC1',
      },
      keyframes: {
        flashfade: { "0%, 100%": { opacity: "0" }, "5%, 80%": { opacity: "1" } },
      },
    },
  },
  plugins: [
    require('@tailwindcss/forms'),
    require('@tailwindcss/aspect-ratio'),
    require('@tailwindcss/typography'),
  ]
}
