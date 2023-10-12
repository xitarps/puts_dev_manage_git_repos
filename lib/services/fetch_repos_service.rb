class FetchReposService
  REPOS_PATH = "#{File.dirname(__FILE__)}/../../repos"

  def self.call(repos)
    run(repos)
  end

  private

  def self.run(repos)
    repos.each do |repo|
      self.create_owner_folder(repo.owner)

      owners_folders = Dir["#{REPOS_PATH}/#{repo.owner}/*"].map { |folder| folder.split('/').last }
      exist_folder = owners_folders.include? project_folder_name(repo)
      repo_folder = "#{REPOS_PATH}/#{repo.owner}/#{project_folder_name(repo)}"

      unless exist_folder
        system "git clone #{repo.url} #{repo_folder}"
      else
        system "git -C #{repo_folder} pull"
      end
    end

    puts "\nRepos baixados ou atualizados com sucesso"
    sleep 2
  end

  def self.create_owner_folder(owner)
    system 'mkdir', '-p', "#{REPOS_PATH}/#{owner}" 
  end

  def self.project_folder_name(repo)
    repo.url.split('/').last
  end
end
