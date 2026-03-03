module UtilityService
  module North
    class ResponseMapper < UtilityService::ResponseMapper
      NOTE_TYPE_MAPPING = {
        'resenia' => 'review',
        'critica' => 'critique'
      }.freeze

      def retrieve_books(_response_code, response_body)
        { books: map_books(response_body['libros']) }
      end

      def retrieve_notes(_response_code, response_body)
        { notes: map_notes(response_body['notas']) }
      end

      private

      def map_books(books)
        books.map do |book|
          {
            id: book['id'],
            title: book['titulo'],
            author: book['autor'],
            genre: book['genero'],
            image_url: book['imagen_url'],
            publisher: book['editorial'],
            year: book['año']
          }
        end
      end

      def build_user_notes(autor)
        {
          email: autor&.dig('datos_de_contacto', 'email'),
          first_name: autor&.dig('datos_personales', 'nombre'),
          last_name: autor&.dig('datos_personales', 'apellido')
        }
      end

      def build_book_notes(book)
        {
          title: book['titulo'],
          author: book['autor'],
          genre: book['genero']
        }
      end

      def parse_note_type(note)
        NOTE_TYPE_MAPPING[note['tipo']&.downcase]
      end

      def build_note(note, note_type)
        {
          title: note['titulo'],
          type: note_type,
          created_at: note['fecha_creacion'],
          content: note['contenido'],
          user: build_user_notes(note['autor']),
          book: build_book_notes(note['libro'])
        }
      end

      def map_notes(notes)
        notes.filter_map do |note|
          note_type = parse_note_type(note)
          next unless note_type
          build_note(note, note_type)
        end
      end
    end
  end
end
