from database import internal_db

if __name__ == '__main__':
    x = internal_db()
    x.update_tussam_lines()
    x.update_tussam_nodes()
    x.close_db()
