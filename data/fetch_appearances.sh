set -xe

scraper_version=v0.0.1

# relative paths
site_map_file=$1
output_file=$2

# for the output file an absolute path is actually easier to handle
output_file=$PWD/$output_file

docker run \
  -v "$(pwd)"/$site_map_file:/app/site_map.json \
  dcaribou/transfermarkt-scraper:$scraper_version \
  scrapy crawl partial -a site_map_file=site_map.json \
  > $output_file

aws s3 rm s3://player-scores/snapshots/$(date +"%Y-%m-%d")
aws s3 cp $output_file s3://player-scores/snapshots/$(date +"%Y-%m-%d")/appearances.json
