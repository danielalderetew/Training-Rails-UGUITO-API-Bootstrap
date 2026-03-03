module UtilityService
  module South
    class ResponseMapper < UtilityService::ResponseMapper
      def retrieve_books(_response_code, response_body)
        { books: map_books(response_body['Libros']) }
      end

      def retrieve_notes(_response_code, response_body)
        { notes: map_notes(response_body['Notas']) }
      end

      private

      def map_books(books)
        books.map do |book|
          {
            id: book['Id'],
            title: book['Titulo'],
            author: book['Autor'],
            genre: book['Genero'],
            image_url: book['ImagenUrl'],
            publisher: book['Editorial'],
            year: book['Año']
          }
        end
      end

      def parse_note_type(note)
        note['ReseniaNota'] ? 'review' : 'note'
      end

      def map_user_notes(autor)
        full_name = autor['NombreCompletoAutor'].to_s.split(/\s+/)
        last_name, *first_names = full_name

        {
          email: autor['EmailAutor'],
          first_name: first_names.join(' '),
          last_name: last_name
        }
      end

      def map_book_notes(book)
        {
          title: book['TituloLibro'],
          author: book['NombreAutorLibro'],
          genre: book['GeneroLibro']
        }
      end

      def map_notes(notes)
        notes.map do |note|
          {
            title: note['TituloNota'],
            type: parse_note_type(note),
            created_at: note['FechaCreacionNota'],
            content: note['Contenido'],
            user: map_user_notes(note),
            book: map_book_notes(note)
          }
        end
      end
    end
  end
end
