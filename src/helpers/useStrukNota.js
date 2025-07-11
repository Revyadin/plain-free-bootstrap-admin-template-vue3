// src/helpers/useStrukNota.js

export function useStrukNota(options = {}) {
  const {
    width = 32,
    fontSize = 13,
    lineChar = '=',
    dashChar = '-'
  } = options

  const padCenter = (text = '') =>
    text.length >= width
      ? text
      : ' '.repeat(Math.floor((width - text.length) / 2)) + text

  const padRight = (text = '', length) =>
    text.length >= length ? text : text + ' '.repeat(length - text.length)

  const padLeft = (text = '', length) =>
    text.length >= length ? text : ' '.repeat(length - text.length) + text

  const separator = (char = lineChar) => char.repeat(width)
  const dashed = () => dashChar.repeat(width)

  const formatItems = (items = []) => {
    const result = []
    for (const item of items) {
      const name = padRight(item.namabarang, width - 16)
      const qty = padLeft(item.quantity + 'x', 3)
      const price = padLeft(item.unit_price, 6)
      const total = padLeft(item.quantity * item.unit_price, 7)
      result.push(`${name}${qty}${price}=${total}`)
    }
    return result
  }

  const generateStruk = (data) => {
    const lines = []
    // console.log(data)
    lines.push(padCenter(data.header || 'STRUK PEMBELIAN'))
    if (data.subheader) lines.push(padCenter(data.subheader))
    if (data.telp) lines.push(padCenter('Telp: ' + data.telp))

    lines.push(separator())
    lines.push(`Nota    : ${data.reference_code || '-'}`)
    lines.push(`Tanggal : ${data.date || '-'}`)
    lines.push(`User    : ${data.user || '-'}`)
    lines.push(dashed())

    lines.push(...formatItems(data.items || []))
    lines.push(dashed())

    lines.push(`Total     : Rp${padLeft(data.total_paid, width - 13)}`)
    // lines.push(`Bayar     : Rp${padLeft(data.bayar, width - 13)}`)
    lines.push(`Kembali   : Rp${padLeft(data.change_returned, width - 13)}`)
    lines.push(separator())
    lines.push(padCenter(data.footer || 'Terima kasih'))
    lines.push('')

    return lines.join('\n')
  }

  const getStrukStyle = () => ({
    fontFamily: "'Courier New', Courier, monospace",
    fontSize: `${fontSize}px`,
    lineHeight: '1.2',
    whiteSpace: 'pre-wrap'
  })

  return {
    generateStruk,
    getStrukStyle
  }
}
