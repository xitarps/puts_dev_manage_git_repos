class Repo < Record
  attr_accessor :owner, :url, :created_at, :updated_at

  @@repos = []

  def initialize(**args)
    @owner      = args[:owner]
    @url        = args[:url]
    @created_at = args[:created_at]
    @updated_at = args[:updated_at]
  end

  def base_path
    "#{File.dirname(__FILE__)}/../../config/database/repos.csv"
  end

  def save
    repo = @@repos.select { |repo| repo.url == url }
    @created_at = repo.first.created_at if repo.any?

    super

    @@repos.delete_if { |repo| repo.url == url }
    @@repos << self
  end

  def self.load_repos
    @@repos = all
  end

  def self.all
    super
  end

  def self.list
    puts "Listando repos...\n\n"
    all.map do |repo|
      puts "#{repo.owner}, #{repo.url}, created at => #{repo.created_at}, updated at => #{repo.updated_at}"
    end
    puts "\nPressione qualquer tecla para continuar..."
    gets
  end

  def self.add
    puts 'Criando novo repo'
    puts "\nEntre com o nome do dono do repositório"
    owner = gets.chomp
    puts "\nEntre com a url do repositório"
    url = gets.chomp

    new(owner:, url:).save
    sleep 2
  end

  def self.delete
    puts 'Apagando repo'
    puts "\nEntre com a url do repositório"
    url = gets.chomp
    @@repos.delete_if { |repo| repo.url == url }
    super(url)
    sleep 2
  end

  def self.fetch
    FetchReposService.call(@@repos)
  end
end
