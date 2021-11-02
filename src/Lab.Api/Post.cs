using System;

namespace Lab.Api
{
    public class Post
    {
        public Post(Guid id)
        {
            Id = id;
        }

        private Post() { }

        public Guid Id { get; private set; }
    }
}
