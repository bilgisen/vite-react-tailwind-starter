# Node.js tabanlı Vite uygulamasını derlemek için temel imaj
FROM node:18-alpine

# Çalışma dizinini ayarla
WORKDIR /app

# package.json ve pnpm-lock.yaml dosyalarını kopyala
COPY package.json pnpm-lock.yaml ./

# Bağımlılıkları yükle (pnpm kullanılarak)
RUN npm install -g pnpm && pnpm install --frozen-lockfile

# Tüm proje dosyalarını kopyala
COPY . .

# Uygulamayı derle (build)
RUN pnpm build

# Statik dosyaları sunmak için Nginx'i kullan
FROM nginx:alpine

# Nginx yapılandırma dosyasını kopyala (oluşturacağız)
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Derlenmiş Vite çıktı dosyalarını Nginx'in sunacağı dizine kopyala
COPY --from=0 /app/dist /usr/share/nginx/html

# Portu açığa çıkar
EXPOSE 80

# Nginx'i başlat
CMD ["nginx", "-g", "daemon off;"]
